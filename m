Return-Path: <linux-kernel-owner+w=401wt.eu-S932146Ab0AEUMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab0AEUMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585Ab0AEUMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:12:01 -0500
Received: from kroah.org ([198.145.64.141]:49960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0AEUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200301.193047791@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Donny Kurnia <donnykurnia@gmail.com>
Subject: [17/39] USB: option: support hi speed for modem Haier CE100
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Donny Kurnia <donnykurnia@gmail.com>

commit c983202bd03eb82394ef1dce5906702fcbc7bb80 upstream.

I made this patch for usbserial driver to add the support for EVDO modem
Haier CE100. The bugs report for this is here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/490068

This patch based on these post:
http://blankblondtank.wordpress.com/2009/09/04/mengoptimalkan-koneksi-modem-haier-ce-100-cdma-di-linux/
http://tantos.web.id/blogs/how-to-internet-connection-using-cdma-evdo-modem-and-karmic-koala-ubuntu-9-10

I hope this patch can help other that have the Haier C100 modem, mostly in my country, Indonesia.

Signed-off-by: Donny Kurnia <donnykurnia@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -337,6 +337,10 @@ static int  option_resume(struct usb_ser
 #define AIRPLUS_VENDOR_ID			0x1011
 #define AIRPLUS_PRODUCT_MCD650			0x3198
 
+/* Haier products */
+#define HAIER_VENDOR_ID				0x201e
+#define HAIER_PRODUCT_CE100			0x2009
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -637,6 +641,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
+	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


