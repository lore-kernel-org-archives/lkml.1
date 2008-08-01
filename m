Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYHAEU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYHAEU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 00:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYHAEUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 00:20:14 -0400
Received: from spam.bandrich.com ([211.72.242.83]:65364 "EHLO
	spam.bandrich.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbYHAEUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 00:20:12 -0400
X-Greylist: delayed 2341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 00:20:11 EDT
Message-Id: <5ECB2A60-5E13-4DE1-86A1-6FA12DBCEF66@bandrich.com>
From: Leon Leong <upleong@bandrich.com>
To: smurf@smurf.noris.de
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: [PATCH] USB: BandRich BandLuxe C150/C250 HSPA Data Card Driver
Date: Fri, 1 Aug 2008 11:40:12 +0800
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
X-Mailer: Apple Mail (2.926)
X-bandrich-MailScanner-Information: Please contact the ISP for more information
X-bandrich-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-bandrich-MailScanner-From: upleong@bandrich.com
X-MAIL: spam.bandrich.com m713eOb8036185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leon Leong <upleong@bandrich.com>

This patch adds the Product ID for the BandLuxe C150/C250 3.5G data  
card series from BandRich Inc.
After detection, the data card works fine.

It was patched against kernel 2.6.27-rc1 with -mm patch

Signed-off-by: Leon Leong <upleong@bandrich.com>

---

Index: drivers/usb/serial/option.c
===================================================================
--- linux-2.6.27-rc1/drivers/usb/serial/option.c.orig	2008-07-29  
10:40:31.000000000 +0800
+++ linux-2.6.27-rc1/drivers/usb/serial/option.c	2008-08-01  
10:28:09.000000000 +0800
@@ -186,6 +186,23 @@ static int  option_send_setup(struct tty
  #define BANDRICH_VENDOR_ID			0x1A8D
  #define BANDRICH_PRODUCT_C100_1			0x1002
  #define BANDRICH_PRODUCT_C100_2			0x1003
+#define BANDRICH_PRODUCT_1004			0x1004
+#define BANDRICH_PRODUCT_1005			0x1005
+#define BANDRICH_PRODUCT_1006			0x1006
+#define BANDRICH_PRODUCT_1007			0x1007
+#define BANDRICH_PRODUCT_1008			0x1008
+#define BANDRICH_PRODUCT_1009			0x1009
+#define BANDRICH_PRODUCT_100A			0x100a
+
+#define BANDRICH_PRODUCT_100B			0x100b
+#define BANDRICH_PRODUCT_100C			0x100c
+#define BANDRICH_PRODUCT_100D			0x100d
+#define BANDRICH_PRODUCT_100E			0x100e
+
+#define BANDRICH_PRODUCT_100F			0x100f
+#define BANDRICH_PRODUCT_1010			0x1010
+#define BANDRICH_PRODUCT_1011			0x1011
+#define BANDRICH_PRODUCT_1012			0x1012

  #define AMOI_VENDOR_ID			0x1614
  #define AMOI_PRODUCT_9508			0x0800
@@ -302,6 +319,21 @@ static struct usb_device_id option_ids[]
  	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_PRODUCT_ET502HS) },
  	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
  	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1004) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1005) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1006) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1007) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1008) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1009) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100A) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100B) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100C) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100D) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100E) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_100F) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1010) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1011) },
+	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_1012) },
  	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC650) },
  	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
  	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */

===================================================================


