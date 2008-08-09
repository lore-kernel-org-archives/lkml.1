Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbYHICth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbYHICth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYHICt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:49:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:24262 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYHICt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=AOF+cgYVgZ6YPdZMuOVKXZx7nGXlUu2RInxJ2xex7zdkNLmVzbrhG0cBW+QEMRAM8d
         hpRoQvpnuSzDkEHBnsRhCWaggDGCf2vjv2rU8iD5s8EX+dCpRv1yBTRX5WW3PUJvIxnt
         iyjWv9wzql0KgwyfdxQD5ua0AinI+WYo7LqwM=
Date: Sat, 9 Aug 2008 04:49:26 +0200
From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add vendor/product id of ZTE MF628 to option
Message-ID: <20080809044926.46c494d9@ors.home>
In-Reply-To: <20080809044530.193a077a@ors.home>
References: <20080809044530.193a077a@ors.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the vendor and product id (19d2:0015) of the ZTE MF628 HSDPA
modem to the option driver. It still needs a mode switch command issued
beforehand, this is currently handled by a userspace tool.

Signed-off-by: Oliver Martin <oliver.martin@student.tuwien.ac.at>

Index: linux-2.6.27-rc2/drivers/usb/serial/option.c
===================================================================
--- linux-2.6.27-rc2.orig/drivers/usb/serial/option.c	2008-08-08 23:10:09.000000000 +0200
+++ linux-2.6.27-rc2/drivers/usb/serial/option.c	2008-08-08 23:10:33.000000000 +0200
@@ -197,6 +197,10 @@
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
 
+/* ZTE PRODUCTS */
+#define ZTE_VENDOR_ID				0x19d2
+#define ZTE_PRODUCT_MF628			0x0015
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -308,6 +312,7 @@
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
+	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
