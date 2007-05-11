Return-Path: <linux-kernel-owner+w=401wt.eu-S1031563AbXEKTws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031563AbXEKTws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763565AbXEKToZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:25 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46655 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965765AbXEKToX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:23 -0400
Message-ID: <4644C792.10607@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:44:18 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trival@kernel.org
Subject: [PATCH] spelling fixes: Documentation/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in Documentation/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 Documentation/DocBook/Makefile             |    2 +-
 Documentation/DocBook/mtdnand.tmpl         |    6 +++---
 Documentation/feature-removal-schedule.txt |    2 +-
 Documentation/isdn/README.concap           |    2 +-
 Documentation/networking/ip-sysctl.txt     |    2 +-
 Documentation/thinkpad-acpi.txt            |    6 +++---
 Documentation/usb/usb-serial.txt           |    2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 6fd1646..005a6af 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -165,7 +165,7 @@ quiet_cmd_db2man = MAN     $@
 	@touch $@
 
 ###
-# Rules to generate postscripts and PNG imgages from .fig format files
+# Rules to generate postscripts and PNG images from .fig format files
 quiet_cmd_fig2eps = FIG2EPS $@
       cmd_fig2eps = fig2dev -Leps $< $@
 
diff --git a/Documentation/DocBook/mtdnand.tmpl b/Documentation/DocBook/mtdnand.tmpl
index a8c8cce..05c8643 100644
--- a/Documentation/DocBook/mtdnand.tmpl
+++ b/Documentation/DocBook/mtdnand.tmpl
@@ -285,7 +285,7 @@ int __init board_init (void)
 	/* Initialize structures */
 	memset ((char *) board_mtd, 0, sizeof(struct mtd_info) + sizeof(struct nand_chip));
 
-	/* map physical adress */
+	/* map physical address */
 	baseaddr = (unsigned long)ioremap(CHIP_PHYSICAL_ADDRESS, 1024);
 	if(!baseaddr){
 		printk("Ioremap to access NAND chip failed\n");
@@ -309,7 +309,7 @@ int __init board_init (void)
 	this->dev_ready = board_dev_ready;
 	this->eccmode = NAND_ECC_SOFT;
 
-	/* Scan to find existance of the device */
+	/* Scan to find existence of the device */
 	if (nand_scan (board_mtd, 1)) {
 		err = -ENXIO;
 		goto out_ior;
@@ -343,7 +343,7 @@ static void __exit board_cleanup (void)
 	/* Release resources, unregister device */
 	nand_release (board_mtd);
 
-	/* unmap physical adress */
+	/* unmap physical address */
 	iounmap((void *)baseaddr);
 	
 	/* Free the MTD device structure */
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c6322c7..7c12c1f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -289,7 +289,7 @@ Why:	Code was merged, then submitter immediately disappeared leaving
 	(interfaces don't return errors so memory allocation can't be
 	handled, calling contexts of these interfaces make handling
 	errors impossible too because they get called after we've
-	totally commited to creating a route object, for example).
+	totally committed to creating a route object, for example).
 	This problem has existed for years and no forward progress
 	has ever been made, and nobody steps up to try and salvage
 	this code, so we're going to finally just get rid of it.
diff --git a/Documentation/isdn/README.concap b/Documentation/isdn/README.concap
index 2f114ba..a76d748 100644
--- a/Documentation/isdn/README.concap
+++ b/Documentation/isdn/README.concap
@@ -111,7 +111,7 @@ struct concap_proto_ops{
 	struct concap_proto *  (*proto_new) (void);
 
 	/* delete encapsulation protocol instance and free all its resources.
-	   cprot may no loger be referenced after calling this */
+	   cprot may no longer be referenced after calling this */
 	void (*proto_del)(struct concap_proto *cprot);
 
 	/* initialize the protocol's data. To be called at interface startup
diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index af6a63a..83d48c4 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -286,7 +286,7 @@ tcp_no_metrics_save - BOOLEAN
 	when the connection closes, so that connections established in the
 	near future can use these to set initial conditions.  Usually, this
 	increases overall performance, but may sometimes cause performance
-	degredation.  If set, TCP will not cache metrics on closing
+	degradation.  If set, TCP will not cache metrics on closing
 	connections.
 
 tcp_orphan_retries - INTEGER
diff --git a/Documentation/thinkpad-acpi.txt b/Documentation/thinkpad-acpi.txt
index 2d48033..8e246c3 100644
--- a/Documentation/thinkpad-acpi.txt
+++ b/Documentation/thinkpad-acpi.txt
@@ -251,7 +251,7 @@ Sysfs notes:
 		0: disables Bluetooth / Bluetooth is disabled
 		1: enables Bluetooth / Bluetooth is enabled.
 
-	Note: this interface will be probably be superseeded by the
+	Note: this interface will be probably be superseded by the
 	generic rfkill class.
 
 Video output control -- /proc/acpi/ibm/video
@@ -928,7 +928,7 @@ Sysfs notes:
 		0: disables WWAN card / WWAN card is disabled
 		1: enables WWAN card / WWAN card is enabled.
 
-	Note: this interface will be probably be superseeded by the
+	Note: this interface will be probably be superseded by the
 	generic rfkill class.
 
 Multiple Commands, Module Parameters
@@ -948,7 +948,7 @@ for example:
 Enabling debugging output
 -------------------------
 
-The module takes a debug paramater which can be used to selectively
+The module takes a debug parameter which can be used to selectively
 enable various classes of debugging output, for example:
 
 	 modprobe ibm_acpi debug=0xffff
diff --git a/Documentation/usb/usb-serial.txt b/Documentation/usb/usb-serial.txt
index 5b635ae..7751f43 100644
--- a/Documentation/usb/usb-serial.txt
+++ b/Documentation/usb/usb-serial.txt
@@ -338,7 +338,7 @@ MCT USB Single Port Serial Adapter U232
   This driver is for the MCT USB-RS232 Converter (25 pin, Model No.
   U232-P25) from Magic Control Technology Corp. (there is also a 9 pin
   Model No. U232-P9). More information about this device can be found at
-  the manufacture's web-site: http://www.mct.com.tw.
+  the manufacturer's web-site: http://www.mct.com.tw.
 
   The driver is generally working, though it still needs some more testing.
   It is derived from the Belkin USB Serial Adapter F5U103 driver and its
-- 
1.5.0.1

-- 
Simon Arlott
