Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbZKFWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbZKFWhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbZKFWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:37:42 -0500
Received: from kroah.org ([198.145.64.141]:56844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453AbZKFWWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:44 2009
Message-Id: <20091106221544.215126415@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Huzaifa Sidhpurwala <sidhpurwala.huzaifa@gmail.com>
Subject: [41/99] USB: option: Support for AIRPLUS MCD650 Datacard
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=usb-option-support-for-airplus-mcd650-datacard.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Huzaifa Sidhpurwala <sidhpurwala.huzaifa@gmail.com>

commit 12148da6722be3b44c2220206b6ccb80d2d9d8f8 upstream.

Here is a patch for Airplus MCD 650 card

Note: This device is with Victor V Kudlak, and he confirmed that this
device works with the patch.

Signed-off-by: Huzaifa Sidhpurwala <sidhpurwala.huzaifa@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -329,6 +329,9 @@ static int  option_resume(struct usb_ser
 #define ALCATEL_VENDOR_ID			0x1bbb
 #define ALCATEL_PRODUCT_X060S			0x0000
 
+/* Airplus products */
+#define AIRPLUS_VENDOR_ID			0x1011
+#define AIRPLUS_PRODUCT_MCD650			0x3198
 
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
@@ -590,6 +593,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
+	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


