Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbYARKz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbYARKz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbYARKzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:55:09 -0500
Received: from MGW3.Sony.CO.JP ([137.153.0.15]:39967 "EHLO mgw3.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYARKzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:55:07 -0500
X-Greylist: delayed 3392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 05:55:07 EST
Date: Fri, 18 Jan 2008 18:58:28 +0900
From: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] usb-serial: pl2303: add support for RATOC REX-USB60F
Message-Id: <20080118185231.0B48.4D252088@rd.scei.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.44 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pl2303: add support for RATOC REX-USB60F

This patch adds support for RATOC REX-USB60F Serial Adapters,
which is widely used in Japan recently.

Signed-off-by: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
---

diff -uprX dontdiff linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.c linux-2.6.24-rc8/drivers/usb/serial/pl2303.c
--- linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.c	2008-01-18 18:11:51.000000000 +0900
+++ linux-2.6.24-rc8/drivers/usb/serial/pl2303.c	2008-01-18 18:43:28.000000000 +0900
@@ -65,6 +65,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID_2080) },
 	{ USB_DEVICE(MA620_VENDOR_ID, MA620_PRODUCT_ID) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID) },
+ 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(TRIPP_VENDOR_ID, TRIPP_PRODUCT_ID) },
 	{ USB_DEVICE(RADIOSHACK_VENDOR_ID, RADIOSHACK_PRODUCT_ID) },
 	{ USB_DEVICE(DCU10_VENDOR_ID, DCU10_PRODUCT_ID) },
diff -uprX dontdiff linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.h linux-2.6.24-rc8/drivers/usb/serial/pl2303.h
--- linux-2.6.24-rc8.orig/drivers/usb/serial/pl2303.h	2008-01-18 18:11:51.000000000 +0900
+++ linux-2.6.24-rc8/drivers/usb/serial/pl2303.h	2008-01-18 18:42:28.000000000 +0900
@@ -35,6 +35,7 @@
 
 #define RATOC_VENDOR_ID		0x0584
 #define RATOC_PRODUCT_ID	0xb000
+#define RATOC_PRODUCT_ID_USB60F	0xb020
 
 #define TRIPP_VENDOR_ID		0x2478
 #define TRIPP_PRODUCT_ID	0x2008


