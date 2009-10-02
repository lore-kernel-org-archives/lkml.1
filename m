Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZJBCC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZJBCC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZJBCCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:02:19 -0400
Received: from kroah.org ([198.145.64.141]:32870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbZJBBc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:06 2009
Message-Id: <20091002012406.637461582@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [006/136] USB: option.c Add support for ZTE AC2726 EVDO modem
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-option.c-add-support-for-zte-ac2726-evdo-modem.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Huzaifa Sidhpurwala <sidhpurwala.huzaifa@gmail.com>

commit a67d8e6c1e49dc919c9d5480583fad8a46fc00aa upstream.

A few days ago i got the latest ZTE EVDO modem shown at:
http://img.alibaba.com/photo/240150115/ZTE_AC2726_EVDO_USB_Data_Modem.jpg

It seems that the latest kernel does not have support for it.
I wrote a small patch for the options.c module to add the relevant usb
ids to it.

From: Huzaifa Sidhpurwala <sidhpurwala.huzaifa@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -299,6 +299,7 @@ static int  option_resume(struct usb_serial *serial);
 #define ZTE_PRODUCT_MF626			0x0031
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
 #define ZTE_PRODUCT_AC8710			0xfff1
+#define ZTE_PRODUCT_AC2726			0xfff5
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -571,6 +572,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },


