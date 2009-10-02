Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZJBBcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZJBBcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZJBBc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:29 -0400
Received: from kroah.org ([198.145.64.141]:32873 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbZJBBc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:06 2009
Message-Id: <20091002012406.772521408@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Manuel Lauss <manuel.lauss@gmail.com>
Subject: [007/136] USB: option: TELIT UC864G support
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-option-telit-uc864g-support.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Manuel Lauss <manuel.lauss@googlemail.com>

commit ce60c48871d2b3a15ab3fa2450e783bebb4ae407 upstream.

Add ID for Telit UC-864G GPS/UMTS/WCDMA modem and GPS receiver
to the option driver.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -292,6 +292,7 @@ static int  option_resume(struct usb_ser
 
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
+#define TELIT_PRODUCT_UC864G			0x1004
 
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -504,6 +505,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0003, 0xff, 0xff, 0xff) },


