Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbZHMTsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbZHMTsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176AbZHMTsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:48:04 -0400
Received: from kroah.org ([198.145.64.141]:36781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbZHMTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:39 2009
Message-Id: <20090813194338.890630696@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dhaval Vasa <dhaval.vasa@einfochips.com>
Subject: [patch 21/28] USB: ftdi_sio: add product_id for Marvell OpenRD Base, Client
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=usb-ftdi_sio-add-product_id-for-marvell-openrd-base-client.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dhaval Vasa <dhaval.vasa@einfochips.com>

commit 50d0678e2026c18e4147f0b16b5853113659b82d upstream.

reference:
http://www.open-rd.org

Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -664,6 +664,8 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
+	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -904,6 +904,13 @@
 #define BAYER_CONTOUR_CABLE_PID        0x6001
 
 /*
+ * Marvell OpenRD Base, Client
+ * http://www.open-rd.org
+ * OpenRD Base, Client use VID 0x0403
+ */
+#define MARVELL_OPENRD_PID	0x9e90
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0


