FROM centos
RUN yum install -y php wget gcc make unzip perl iproute lsof httpd
RUN /usr/sbin/useradd nagios && /usr/sbin/groupadd nagcmd && /usr/sbin/usermod -a -G nagcmd nagios && /usr/sbin/usermod -a -G nagcmd apache
RUN wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.4.3.tar.gz && tar xfvz nagios-4.4.3.tar.gz && cd nagios-4.4.3 && ./configure --with-command-group=nagcmd && make all && make install && make install-init && make install-config && make install-commandmode && cat sample-config/httpd.conf >> /etc/httpd/conf.d/nagios.conf
RUN htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios
RUN systemctl enable httpd && systemctl enable nagios
RUN wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz && tar zxf nagios-plugins-2.2.1.tar.gz && cd nagios-plugins-2.2.1 && ./configure --with-nagios-user=nagios --with-nagios-group=nagios && make -j 4 && make install
RUN rm -rf /nagios*
EXPOSE 80
CMD ["/usr/sbin/init"]

