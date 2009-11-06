Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbZKFWg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbZKFWg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932920AbZKFWgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:36:55 -0500
Received: from kroah.org ([198.145.64.141]:56851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167AbZKFWWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:44 2009
Message-Id: <20091106221544.356196567@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bryan Wu <bryan.wu@canonical.com>,
       Matthias Urlichs <matthias@urlichs.de>
Subject: [42/99] USB: option: TLAYTECH TUE800 support
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=usb-option-tlaytech-tue800-support.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bryan Wu <bryan.wu@canonical.com>

commit fead2ab6cf9ad3a84a06e68ccc20d1e460fad13e upstream.

Add ID for Tlaytech TUE800 CDMA modem to the option driver.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-By: Matthias Urlichs <matthias@urlichs.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -316,6 +316,9 @@ static int  option_resume(struct usb_ser
 #define QISDA_PRODUCT_H20_4515			0x4515
 #define QISDA_PRODUCT_H20_4519			0x4519
 
+/* TLAYTECH PRODUCTS */
+#define TLAYTECH_VENDOR_ID			0x20B9
+#define TLAYTECH_PRODUCT_TEU800			0x1682
 
 /* TOSHIBA PRODUCTS */
 #define TOSHIBA_VENDOR_ID			0x0930
@@ -594,6 +597,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
+	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


