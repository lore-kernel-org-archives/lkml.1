Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbZJPR0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbZJPR0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZJPRSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:23 -0400
Received: from kroah.org ([198.145.64.141]:48485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZJPRSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:22 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:54 2009
Message-Id: <20091016171153.640382260@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Magdina <peter@magdina.sk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [14/46] USB: option: Toshiba G450 device id
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-option-toshiba-g450-device-id.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Magdina <peter@magdina.sk>

commit 75f47214f90e996eb184eb6e6b0e8b817999c8f7 upstream.

Signed-off-by: Peter Magdina <peter@magdina.sk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -319,6 +319,7 @@ static int  option_resume(struct usb_ser
 /* TOSHIBA PRODUCTS */
 #define TOSHIBA_VENDOR_ID			0x0930
 #define TOSHIBA_PRODUCT_HSDPA_MINICARD		0x1302
+#define TOSHIBA_PRODUCT_G450			0x0d45
 
 #define ALINK_VENDOR_ID				0x1e0e
 #define ALINK_PRODUCT_3GU			0x9200
@@ -582,6 +583,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4523) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4515) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H20_4519) },
+	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_G450) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },


