Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbZKFWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbZKFWgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbZKFWWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:55 -0500
Received: from kroah.org ([198.145.64.141]:56842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447AbZKFWWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:44 2009
Message-Id: <20091106221544.085690413@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [40/99] USB: option: Patch for Huawei Mobile Broadband E270+ Modem
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=usb-option-patch-for-huawei-mobile-broadband-e270-modem.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ronnie Furuskog <rofu7@hotmail.com>

commit 0ee3a33a0481c8f5c9edb7a5a02f3c76496d9551 upstream.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -166,6 +166,7 @@ static int  option_resume(struct usb_ser
 #define HUAWEI_PRODUCT_E143D			0x143D
 #define HUAWEI_PRODUCT_E143E			0x143E
 #define HUAWEI_PRODUCT_E143F			0x143F
+#define HUAWEI_PRODUCT_E14AC			0x14AC
 
 #define QUANTA_VENDOR_ID			0x0408
 #define QUANTA_PRODUCT_Q101			0xEA02
@@ -426,6 +427,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143D, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143E, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E143F, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */


