Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbXCPN23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbXCPN23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXCPN23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:28:29 -0400
Received: from relay4.usu.ru ([194.226.235.39]:41331 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbXCPN22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:28:28 -0400
Message-ID: <45FA9B8B.6000703@ums.usu.ru>
Date: Fri, 16 Mar 2007 18:28:43 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>
Subject: [PATCH][TRIVIAL] Fix path to modules.txt in Kconfig help
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/modules.txt doesn't exist, but 
Documentation/kbuild/modules.txt does.

Signed-off-by: Alexander E. Patrakov

--- linux/drivers/mtd/devices/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/drivers/mtd/devices/Kconfig	2007-03-16 18:18:35.000000000 +0500
@@ -49,8 +49,8 @@
 
 	  If you want to compile this driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module will
-	  be called ms02-nv.o.
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
+	  The module will be called ms02-nv.ko.
 
 config MTD_DATAFLASH
 	tristate "Support for AT45xxx DataFlash"
--- linux/drivers/net/wireless/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/drivers/net/wireless/Kconfig	2007-03-16 18:20:05.000000000 +0500
@@ -169,8 +169,8 @@
  
           If you want to compile the driver as a module ( = code which can be
           inserted in and removed from the running kernel whenever you want),
-          say M here and read <file:Documentation/modules.txt>.  The module
-          will be called ipw2100.ko.
+          say M here and read <file:Documentation/kbuild/modules.txt>.
+          The module will be called ipw2100.ko.
 	
 config IPW2100_MONITOR
         bool "Enable promiscuous mode"
@@ -223,8 +223,8 @@
  
           If you want to compile the driver as a module ( = code which can be
           inserted in and removed from the running kernel whenever you want),
-          say M here and read <file:Documentation/modules.txt>.  The module
-          will be called ipw2200.ko.
+          say M here and read <file:Documentation/kbuild/modules.txt>.
+          The module will be called ipw2200.ko.
 
 config IPW2200_MONITOR
         bool "Enable promiscuous mode"
@@ -518,8 +518,8 @@
 	  
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called prism54.ko.
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
+	  The module will be called prism54.ko.
 
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
--- linux/drivers/net/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/drivers/net/Kconfig	2007-03-16 18:20:53.000000000 +0500
@@ -843,8 +843,8 @@
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
 	  The module will be called smc91x.  If you want to compile it as a
-	  module, say M here and read <file:Documentation/modules.txt> as well
-	  as <file:Documentation/networking/net-modules.txt>.
+	  module, say M here and read <file:Documentation/kbuild/modules.txt>
+	  as well as <file:Documentation/networking/net-modules.txt>.
 
 config SMC9194
 	tristate "SMC 9194 support"
@@ -899,7 +899,7 @@
 
 	  This driver is also available as a module. The module will be 
 	  called smc911x.  If you want to compile it as a module, say M 
-	  here and read <file:Documentation/modules.txt>
+	  here and read <file:Documentation/kbuild/modules.txt>
 
 config NET_VENDOR_RACAL
 	bool "Racal-Interlan (Micom) NI cards"
--- linux/drivers/scsi/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/drivers/scsi/Kconfig	2007-03-16 18:15:44.000000000 +0500
@@ -170,7 +170,7 @@
 	
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt> and
+	  say M here and read <file:Documentation/kbuild/modules.txt> and
 	  <file:Documentation/scsi.txt>. The module will be called ch.o.
 	  If unsure, say N.
 	
@@ -1777,7 +1777,7 @@
 
           This driver is also available as a module. This module will be
           called zfcp. If you want to compile it as a module, say M here
-          and read <file:Documentation/modules.txt>.
+          and read <file:Documentation/kbuild/modules.txt>.
 
 config SCSI_SRP
 	tristate "SCSI RDMA Protocol helper library"
--- linux/drivers/video/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/drivers/video/Kconfig	2007-03-16 18:15:44.000000000 +0500
@@ -175,7 +175,7 @@
 
 	  If you want to compile this as a module (=code which can be
 	  inserted into and removed from the running kernel), say M
-	  here and read <file:Documentation/modules.txt>.  The module
+	  here and read <file:Documentation/kbuild/modules.txt>.  The module
 	  will be called amba-clcd.
 
 choice
@@ -1520,7 +1520,7 @@
 	  This driver is also available as a module ( = code which can be
 	  inserted and removed from the running kernel whenever you want). The
 	  module will be called pxafb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/modules.txt>.
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
 
 	  If unsure, say N.
 
@@ -1573,7 +1573,7 @@
 	  This driver is also available as a module ( = code which can be
 	  inserted and removed from the running kernel whenever you want). The
 	  module will be called w100fb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/modules.txt>.
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
 
 	  If unsure, say N.
 
@@ -1590,7 +1590,7 @@
 	  This driver is also available as a module ( = code which can be
 	  inserted and removed from the running kernel whenever you want). The
 	  module will be called s3c2410fb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/modules.txt>.
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
 
 	  If unsure, say N.
 config FB_S3C2410_DEBUG
--- linux/net/ipv6/netfilter/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/net/ipv6/netfilter/Kconfig	2007-03-16 18:15:44.000000000 +0500
@@ -189,7 +189,7 @@
 	  and OUTPUT chains.
 	
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 endmenu
 
--- linux/net/netfilter/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/net/netfilter/Kconfig	2007-03-16 18:22:22.000000000 +0500
@@ -132,7 +132,7 @@
 	  tracking code will be able to do state tracking on SCTP connections.
 
 	  If you want to compile it as a module, say M here and read
-	  Documentation/modules.txt.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
@@ -296,8 +296,8 @@
 	  affects the connection mark value rather than the packet mark value.
 	
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  The module will be called
-	  ipt_CONNMARK.o.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  The module will be called
+	  ipt_CONNMARK.ko.  If unsure, say `N'.
 
 config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" target support'
@@ -358,7 +358,7 @@
 	  no protocol helpers for the selected packets).
 	
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
@@ -390,7 +390,7 @@
 	  comments in your iptables ruleset.
 
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
@@ -401,7 +401,7 @@
 	  number of bytes and/or packets for each direction within a connection.
 
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
@@ -412,8 +412,8 @@
 	  connection mark value previously set for the session by `CONNMARK'. 
 	
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  The module will be called
-	  ipt_connmark.o.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  The module will be called
+	  ipt_connmark.ko.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_CONNTRACK
 	tristate '"conntrack" connection tracking match support'
@@ -437,7 +437,7 @@
 	  and DCCP flags.
 
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_DSCP
 	tristate '"DSCP" match support'
@@ -556,7 +556,7 @@
 	  byte counter.
 
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_REALM
 	tristate  '"realm" match support'
@@ -570,7 +570,7 @@
 	  in tc world.
 	
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
@@ -581,7 +581,7 @@
 	  and SCTP chunk types.
 
 	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_STATE
 	tristate '"state" match support'
--- linux/net/tipc/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/net/tipc/Kconfig	2007-03-16 18:15:44.000000000 +0500
@@ -18,7 +18,7 @@
 	  This protocol support is also available as a module ( = code which
 	  can be inserted in and removed from the running kernel whenever you
 	  want). The module will be called tipc. If you want to compile it
-	  as a module, say M here and read <file:Documentation/modules.txt>.
+	  as a module, say M here and read <file:Documentation/kbuild/modules.txt>.
 
 	  If in doubt, say N.
 


