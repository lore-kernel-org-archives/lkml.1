Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675Ab0AEAxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0AEAxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756Ab0AEAxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:53:38 -0500
Received: from kroah.org ([198.145.64.141]:34151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0AEAez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Donny Kurnia <donnykurnia@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/97] USB: option: support hi speed for modem Haier CE100
Date: Mon,  4 Jan 2010 16:32:34 -0800
Message-Id: <1262651630-7354-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index dffc8a1..be3dff1 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -340,6 +340,10 @@ static int  option_resume(struct usb_serial *serial);
 #define FOUR_G_SYSTEMS_VENDOR_ID		0x1c9e
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
 
+/* Haier products */
+#define HAIER_VENDOR_ID				0x201e
+#define HAIER_PRODUCT_CE100			0x2009
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -641,6 +645,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
+	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.6.6

