Return-Path: <linux-kernel-owner+w=401wt.eu-S933105AbXA2Cun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbXA2Cun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 21:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933109AbXA2Cun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 21:50:43 -0500
Received: from outbound0.mx.meer.net ([209.157.153.23]:3018 "EHLO
	outbound0.sv.meer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105AbXA2Cum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 21:50:42 -0500
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH -mm] fix DocBook build
References: <20070127234928.64d8e437.akpm@osdl.org>
From: Don Mullis <dwm@meer.net>
Date: Sun, 28 Jan 2007 18:50:25 -0800
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org> (Andrew Morton's message of "Sat\, 27 Jan 2007 23\:49\:28 -0800")
Message-ID: <m31wleczri.fsf@meer.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix DocBook build.
Regression was introduced by
gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch

Tested by `make htmldocs`.

Signed-off-by: Don Mullis <dwm@meer.net>
Cc: gregkh@suse.de
---
 Documentation/DocBook/gadget.tmpl |    4 ++--
 Documentation/DocBook/usb.tmpl    |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.19/Documentation/DocBook/gadget.tmpl
===================================================================
--- linux-2.6.19.orig/Documentation/DocBook/gadget.tmpl
+++ linux-2.6.19/Documentation/DocBook/gadget.tmpl
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
Index: linux-2.6.19/Documentation/DocBook/usb.tmpl
===================================================================
--- linux-2.6.19.orig/Documentation/DocBook/usb.tmpl
+++ linux-2.6.19/Documentation/DocBook/usb.tmpl
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
