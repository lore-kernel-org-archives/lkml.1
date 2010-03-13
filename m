Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935697Ab0CMApl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:45:41 -0500
Received: from kroah.org ([198.145.64.141]:47204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935542Ab0CMAc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:28 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:16 2010
Message-Id: <20100313002716.314900993@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Sangorrin <daniel.sangorrin@gmail.com>,
       Andreas Mohr <andi@lisas.de>
Subject: [127/145] USB: serial: ftdi: add CONTEC vendor and product id
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Daniel Sangorrin <daniel.sangorrin@gmail.com>

commit 46b72d78cb022714c89a9ebc00b9581b550cfca7 upstream.

This is a patch to ftdi_sio_ids.h and ftdi_sio.c that adds
identifiers for CONTEC USB serial converter. I tested it
with the device COM-1(USB)H

Signed-off-by: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -614,6 +614,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_OCEANIC_PID) },
 	{ USB_DEVICE(TTI_VID, TTI_QL355P_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
+	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -494,6 +494,13 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020
 
 /*
+ * Contec products (http://www.contec.com)
+ * Submitted by Daniel Sangorrin
+ */
+#define CONTEC_VID		0x06CE	/* Vendor ID */
+#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
+
+/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */


