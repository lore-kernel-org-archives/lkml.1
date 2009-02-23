Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZBWPe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZBWPe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbZBWPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:34:20 -0500
Received: from ostendo.netzorz.se ([213.136.44.98]:51841 "EHLO mail.netzorz.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754516AbZBWPeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:34:19 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 10:34:19 EST
Subject: [PATCH] Support for second revision of Ericsson F3507G WWAN card
From: Patrik Kullman <patrik@yes.nu>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-vM4YhmGSPx3pR/zKvZ64"
Date: Mon, 23 Feb 2009 16:25:00 +0100
Message-Id: <1235402700.32528.27.camel@narya>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vM4YhmGSPx3pR/zKvZ64
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I noticed that my revision of the F3507G WWAN card isn't listed in
drivers/usb/serial/option.c


Patch to add it attached.

--=-vM4YhmGSPx3pR/zKvZ64
Content-Disposition: attachment; filename="linux-usb-serial-f3507g2.patch"
Content-Type: text/x-patch; name="linux-usb-serial-f3507g2.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

--- linux-2.6.28/drivers/usb/serial/option.c.orig	2009-02-23 16:19:53.000000000 +0100
+++ linux-2.6.28/drivers/usb/serial/option.c	2009-02-23 16:21:05.000000000 +0100
@@ -265,7 +265,8 @@
 
 /* Ericsson products */
 #define ERICSSON_VENDOR_ID			0x0bdb
-#define ERICSSON_PRODUCT_F3507G			0x1900
+#define ERICSSON_PRODUCT_F3507G_1		0x1900
+#define ERICSSON_PRODUCT_F3507G_2		0x1902
 
 /* Pantech products */
 #define PANTECH_VENDOR_ID			0x106c
@@ -475,7 +476,8 @@
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
-	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G) },
+	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G_1) },
+	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G_2) },
 	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_PC5740) },
 	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_PC5750) },
 	{ USB_DEVICE(PANTECH_VENDOR_ID, PANTECH_PRODUCT_UM150) },

--=-vM4YhmGSPx3pR/zKvZ64--

