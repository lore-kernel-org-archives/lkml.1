Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935749Ab0CMAqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:46:10 -0500
Received: from kroah.org ([198.145.64.141]:47192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935537Ab0CMAc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:26 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:16 2010
Message-Id: <20100313002716.060769225@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Radek Liboska <liboska@uochb.cas.cz>
Subject: [124/145] USB: ftdi_sio: new device id for papouch AD4USB
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Radek Liboska <liboska@uochb.cas.cz>

commit a7787e508acb4378d62f4584bae3dd1cd0ba3eac upstream.

added new device pid (PAPOUCH_AD4USB_PID) to ftdi_sio.h and ftdi_sio.c

AD4USB measuring converter is a 4-input A/D converter which enables the
user to measure to four current inputs ranging from 0(4) to 20 mA or
voltage between 0 and 10 V. The measured values are then transferred to
a superior system in digital form. The AD4USB communicates via USB.
Powered is also via USB.  datasheet in english is here:
http://www.papouch.com/shop/scripts/pdf/ad4usb_en.pdf


Signed-off-by: Radek Liboska <liboska@uochb.cas.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -697,6 +697,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
+	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_AD4USB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
 	{ USB_DEVICE(ALTI2_VID, ALTI2_N3_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -968,6 +968,7 @@
 #define PAPOUCH_VID			0x5050	/* Vendor ID */
 #define PAPOUCH_TMU_PID			0x0400	/* TMU USB Thermometer */
 #define PAPOUCH_QUIDO4x4_PID		0x0900	/* Quido 4/4 Module */
+#define PAPOUCH_AD4USB_PID		0x8003	/* AD4USB Measurement Module */
 
 /*
  * Marvell SheevaPlug


