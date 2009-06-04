Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZFDOcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZFDOcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZFDOcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:32:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32876 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFDOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:32:23 -0400
Date: Thu, 4 Jun 2009 16:32:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Kconfig: .ko is normally not included in kconfig help
Message-ID: <20090604143221.GG29005@elf.ucw.cz>
References: <20090514111556.GA9347@elf.ucw.cz> <alpine.LNX.2.00.0905141350320.22712@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0905141350320.22712@wotan.suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


.ko is normally not included in Kconfig help, make it consistent.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
commit 7ca0c98aa0bc0d6d3c27ab40e1ca4021a72b960d
tree 2fc714be60b4def0ea0b8c4e4d07e0f9e5beb66d
parent e667f8f9189e8bd191ba9a0656d8b3fd47c41e8a
author Pavel <pavel@ucw.cz> Thu, 04 Jun 2009 16:31:50 +0200
committer Pavel <pavel@ucw.cz> Thu, 04 Jun 2009 16:31:50 +0200

 drivers/crypto/Kconfig              |    6 +++---
 drivers/net/wireless/hostap/Kconfig |    8 ++++----
 drivers/net/wireless/rt2x00/Kconfig |   14 +++++++-------
 drivers/s390/net/Kconfig            |   14 +++++++-------
 net/netfilter/Kconfig               |    4 ++--
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 01afd75..3e72a6a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -34,7 +34,7 @@ config CRYPTO_DEV_PADLOCK_AES
 	  Available in VIA C3 and newer CPUs.
 
 	  If unsure say M. The compiled module will be
-	  called padlock-aes.ko
+	  called padlock-aes.
 
 config CRYPTO_DEV_PADLOCK_SHA
 	tristate "PadLock driver for SHA1 and SHA256 algorithms"
@@ -47,7 +47,7 @@ config CRYPTO_DEV_PADLOCK_SHA
 	  Available in VIA C7 and newer processors.
 
 	  If unsure say M. The compiled module will be
-	  called padlock-sha.ko
+	  called padlock-sha.
 
 config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
@@ -79,7 +79,7 @@ config ZCRYPT_MONOLITHIC
 	bool "Monolithic zcrypt module"
 	depends on ZCRYPT="m"
 	help
-	  Select this option if you want to have a single module z90crypt.ko
+	  Select this option if you want to have a single module z90crypt,
 	  that contains all parts of the crypto device driver (ap bus,
 	  request router and all the card drivers).
 
diff --git a/drivers/net/wireless/hostap/Kconfig b/drivers/net/wireless/hostap/Kconfig
index 932d207..c15db22 100644
--- a/drivers/net/wireless/hostap/Kconfig
+++ b/drivers/net/wireless/hostap/Kconfig
@@ -29,7 +29,7 @@ config HOSTAP
 	PLX/PCI/CS version of the driver to actually use the driver.
 
 	The driver can be compiled as a module and it will be called
-	"hostap.ko".
+	hostap.
 
 config HOSTAP_FIRMWARE
 	bool "Support downloading firmware images with Host AP driver"
@@ -68,7 +68,7 @@ config HOSTAP_PLX
 	driver.
 
 	The driver can be compiled as a module and will be named
-	"hostap_plx.ko".
+	hostap_plx.
 
 config HOSTAP_PCI
 	tristate "Host AP driver for Prism2.5 PCI adaptors"
@@ -81,7 +81,7 @@ config HOSTAP_PCI
 	driver.
 
 	The driver can be compiled as a module and will be named
-	"hostap_pci.ko".
+	hostap_pci.
 
 config HOSTAP_CS
 	tristate "Host AP driver for Prism2/2.5/3 PC Cards"
@@ -94,4 +94,4 @@ config HOSTAP_CS
 	driver.
 
 	The driver can be compiled as a module and will be named
-	"hostap_cs.ko".
+	hostap_cs.
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index bfc5d9c..1ae11c7 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -9,11 +9,11 @@ menuconfig RT2X00
 
 	  When building one of the individual drivers, the rt2x00 library
 	  will also be created. That library (when the driver is built as
-	  a module) will be called "rt2x00lib.ko".
+	  a module) will be called rt2x00lib.
 
 	  Additionally PCI and USB libraries will also be build depending
 	  on the types of drivers being selected, these libraries will be
-	  called "rt2x00pci.ko" and "rt2x00usb.ko".
+	  called rt2x00pci and rt2x00usb.
 
 if RT2X00
 
@@ -26,7 +26,7 @@ config RT2400PCI
 	  This adds support for rt2400 wireless chipset family.
 	  Supported chips: RT2460.
 
-	  When compiled as a module, this driver will be called "rt2400pci.ko".
+	  When compiled as a module, this driver will be called rt2400pci.
 
 config RT2500PCI
 	tristate "Ralink rt2500 (PCI/PCMCIA) support"
@@ -37,7 +37,7 @@ config RT2500PCI
 	  This adds support for rt2500 wireless chipset family.
 	  Supported chips: RT2560.
 
-	  When compiled as a module, this driver will be called "rt2500pci.ko".
+	  When compiled as a module, this driver will be called rt2500pci.
 
 config RT61PCI
 	tristate "Ralink rt2501/rt61 (PCI/PCMCIA) support"
@@ -51,7 +51,7 @@ config RT61PCI
 	  This adds support for rt2501 wireless chipset family.
 	  Supported chips: RT2561, RT2561S & RT2661.
 
-	  When compiled as a module, this driver will be called "rt61pci.ko".
+	  When compiled as a module, this driver will be called rt61pci.
 
 config RT2500USB
 	tristate "Ralink rt2500 (USB) support"
@@ -62,7 +62,7 @@ config RT2500USB
 	  This adds support for rt2500 wireless chipset family.
 	  Supported chips: RT2571 & RT2572.
 
-	  When compiled as a module, this driver will be called "rt2500usb.ko".
+	  When compiled as a module, this driver will be called rt2500usb.
 
 config RT73USB
 	tristate "Ralink rt2501/rt73 (USB) support"
@@ -75,7 +75,7 @@ config RT73USB
 	  This adds support for rt2501 wireless chipset family.
 	  Supported chips: RT2571W, RT2573 & RT2671.
 
-	  When compiled as a module, this driver will be called "rt73usb.ko".
+	  When compiled as a module, this driver will be called rt73usb.
 
 config RT2X00_LIB_PCI
 	tristate
diff --git a/drivers/s390/net/Kconfig b/drivers/s390/net/Kconfig
index a7745c8..cb909a5 100644
--- a/drivers/s390/net/Kconfig
+++ b/drivers/s390/net/Kconfig
@@ -8,7 +8,7 @@ config LCS
 	   Select this option if you want to use LCS networking on IBM System z.
 	   This device driver supports Token Ring (IEEE 802.5),
 	   FDDI (IEEE 802.7) and Ethernet.
-	   To compile as a module, choose M. The module name is lcs.ko.
+	   To compile as a module, choose M. The module name is lcs.
 	   If you do not know what it is, it's safe to choose Y.
 
 config CTCM
@@ -21,7 +21,7 @@ config CTCM
 	  It also supports virtual CTCs when running under VM.
 	  This driver also supports channel-to-channel MPC SNA devices.
 	  MPC is an SNA protocol device used by Communication Server for Linux.
-	  To compile as a module, choose M. The module name is ctcm.ko.
+	  To compile as a module, choose M. The module name is ctcm.
 	  To compile into the kernel, choose Y.
 	  If you do not need any channel-to-channel connection, choose N.
 
@@ -34,7 +34,7 @@ config NETIUCV
 	  link between VM guests. Using ifconfig a point-to-point connection
 	  can be established to the Linux on IBM System z
 	  running on the other VM guest. To compile as a module, choose M.
-	  The module name is netiucv.ko. If unsure, choose Y.
+	  The module name is netiucv. If unsure, choose Y.
 
 config SMSGIUCV
 	tristate "IUCV special message support (VM only)"
@@ -50,7 +50,7 @@ config CLAW
 	  This driver supports channel attached CLAW devices.
 	  CLAW is Common Link Access for Workstation.  Common devices
           that use CLAW are RS/6000s, Cisco Routers (CIP) and 3172 devices.
-	  To compile as a module, choose M. The module name is claw.ko.
+	  To compile as a module, choose M. The module name is claw.
 	  To compile into the kernel, choose Y.
 
 config QETH
@@ -65,14 +65,14 @@ config QETH
 	  <http://www.ibm.com/developerworks/linux/linux390>
 
 	  To compile this driver as a module, choose M.
-	  The module name is qeth.ko.
+	  The module name is qeth.
 
 config QETH_L2
         tristate "qeth layer 2 device support"
         depends on QETH
         help
           Select this option to be able to run qeth devices in layer 2 mode.
-          To compile as a module, choose M. The module name is qeth_l2.ko.
+          To compile as a module, choose M. The module name is qeth_l2.
           If unsure, choose y.
 
 config QETH_L3
@@ -80,7 +80,7 @@ config QETH_L3
         depends on QETH
         help
           Select this option to be able to run qeth devices in layer 3 mode.
-          To compile as a module choose M. The module name is qeth_l3.ko.
+          To compile as a module choose M. The module name is qeth_l3.
           If unsure, choose Y.
 
 config QETH_IPV6
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index cb3ad74..c26a20c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -327,7 +327,7 @@ config NETFILTER_XT_TARGET_CONNMARK
 
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  The module will be called
-	  ipt_CONNMARK.ko.  If unsure, say `N'.
+	  ipt_CONNMARK.  If unsure, say `N'.
 
 config NETFILTER_XT_TARGET_CONNSECMARK
 	tristate '"CONNSECMARK" target support'
@@ -584,7 +584,7 @@ config NETFILTER_XT_MATCH_CONNMARK
 
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  The module will be called
-	  ipt_connmark.ko.  If unsure, say `N'.
+	  ipt_connmark.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_CONNTRACK
 	tristate '"conntrack" connection tracking match support'


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
