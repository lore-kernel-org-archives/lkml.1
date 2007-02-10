Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXBJWqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXBJWqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXBJWp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:45:57 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43589 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXBJWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:45:52 -0500
Date: Sat, 10 Feb 2007 14:41:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: gregkh@suse.de
Cc: lkml <linux-kernel@vger.kernel.org>,
       lud <linux-usb-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] USB kernel-doc fixes
Message-Id: <20070210144141.a3717af3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings and errors in USB.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/gadget.tmpl |    4 ++--
 Documentation/DocBook/usb.tmpl    |    6 +++---
 drivers/usb/core/driver.c         |    1 +
 3 files changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.20-git6.orig/Documentation/DocBook/usb.tmpl
+++ linux-2.6.20-git6/Documentation/DocBook/usb.tmpl
@@ -187,13 +187,13 @@
 
 <chapter><title>USB-Standard Types</title>
 
-    <para>In <filename>&lt;linux/usb_ch9.h&gt;</filename> you will find
+    <para>In <filename>&lt;linux/usb/ch9.h&gt;</filename> you will find
     the USB data types defined in chapter 9 of the USB specification.
     These data types are used throughout USB, and in APIs including
     this host side API, gadget APIs, and usbfs.
     </para>
 
-!Iinclude/linux/usb_ch9.h
+!Iinclude/linux/usb/ch9.h
 
     </chapter>
 
@@ -574,7 +574,7 @@ for (;;) {
 #include &lt;asm/byteorder.h&gt;</programlisting>
 	    The standard USB device model requests, from "Chapter 9" of
 	    the USB 2.0 specification, are automatically included from
-	    the <filename>&lt;linux/usb_ch9.h&gt;</filename> header.
+	    the <filename>&lt;linux/usb/ch9.h&gt;</filename> header.
 	    </para>
 
 	    <para>Unless noted otherwise, the ioctl requests
--- linux-2.6.20-git6.orig/Documentation/DocBook/gadget.tmpl
+++ linux-2.6.20-git6/Documentation/DocBook/gadget.tmpl
@@ -482,13 +482,13 @@ slightly.
 <para>Gadget drivers
 rely on common USB structures and constants
 defined in the
-<filename>&lt;linux/usb_ch9.h&gt;</filename>
+<filename>&lt;linux/usb/ch9.h&gt;</filename>
 header file, which is standard in Linux 2.6 kernels.
 These are the same types and constants used by host
 side drivers (and usbcore).
 </para>
 
-!Iinclude/linux/usb_ch9.h
+!Iinclude/linux/usb/ch9.h
 </sect1>
 
 <sect1 id="core"><title>Core Objects and Methods</title>
--- linux-2.6.20-git6.orig/drivers/usb/core/driver.c
+++ linux-2.6.20-git6/drivers/usb/core/driver.c
@@ -743,6 +743,7 @@ EXPORT_SYMBOL_GPL(usb_deregister_device_
  * usb_register_driver - register a USB interface driver
  * @new_driver: USB operations for the interface driver
  * @owner: module owner of this driver.
+ * @mod_name: module name string
  *
  * Registers a USB interface driver with the USB core.  The list of
  * unattached interfaces will be rescanned whenever a new driver is
