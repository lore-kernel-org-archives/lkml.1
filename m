Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZJBBdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZJBBdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZJBBdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:11 -0400
Received: from kroah.org ([198.145.64.141]:33121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbZJBBdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:13 2009
Message-Id: <20091002012413.693553000@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pawel Ludwikow <pludwiko@rab.ict.pwr.wroc.pl>
Subject: [050/136] USB: serial: pl2303: new hardware support - sanwa multimeter
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-pl2303-new-hardware-support-sanwa-multimeter.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Pawel Ludwikow <pludwiko@rab.ict.pwr.wroc.pl>

commit 35904e6b5106fda51b04c8b8080c04466865415f upstream.

I'd like to present my small patch enabling to use Sanwa PC5000
mulitimeter with linux.

Signed-off-by: Pawel Ludwikow <pludwiko@rab.ict.pwr.wroc.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -96,6 +96,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
+	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -130,3 +130,7 @@
 /* Sony, USB data cable for CMD-Jxx mobile phones */
 #define SONY_VENDOR_ID		0x054c
 #define SONY_QN3USB_PRODUCT_ID	0x0437
+
+/* Sanwa KB-USB2 multimeter cable (ID: 11ad:0001) */
+#define SANWA_VENDOR_ID		0x11ad
+#define SANWA_PRODUCT_ID	0x0001


