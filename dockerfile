FROM ubuntu
MAINTAINER yc <xd_chengyang@163.com>
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget -y
#安装jdk
RUN mkdir /opt/jdk
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  -P /opt/jdk "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
RUN tar xzf /opt/jdk/jdk-8u141-linux-x64.tar.gz -C /opt/jdk && rm -rf /opt/jdk-8u141-linux-x64.tar.gz

#安装tomcat
RUN mkdir /opt/tomcat
RUN wget -P  /opt/tomcat http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz
RUN tar xzf /opt/tomcat/apache-tomcat-8.5.8.tar.gz -C /opt/tomcat && rm -rf /opt/tomcat/apache-tomcat-8.5.8.tar.gz


#安装maven
RUN mkdir /opt/maven
RUN wget -P /opt/maven http://apache-mirror.rbc.ru/pub/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN tar xzvf /opt/maven/apache-maven-3.3.9-bin.tar.gz -C /opt/maven && rm -rf /opt/maven/apache-maven-3.3.9.tar.gz


#设置环境变量
ENV JAVA_HOME /opt/jdk/jdk1.8.0_141
ENV M2_HOME=/opt/maven/apache-maven-3.3.9
ENV CATALINA_HOME /opt/tomcat/apache-tomcat-8.5.8
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$M2_HOME/bin


#打包项目并拷贝到tomcat webapps目录
RUN mkdir /opt/webapp
ADD ./  /opt/webapp
RUN cd  /opt/webapp  && cp /opt/webapp/shopping.war /opt/tomcat/apache-tomcat-8.5.8/webapps/

#开启内部服务端口
EXPOSE 8080

#启动tomcat服务器
CMD ["./opt/tomcat/apache-tomcat-8.5.8/bin/catalina.sh","run"] && tail -f /opt/tomcat/apache-tomcat-8.5.8/logs/catalina.out 

