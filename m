Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935701Ab0CMAp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:45:58 -0500
Received: from kroah.org ([198.145.64.141]:47201 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935540Ab0CMAc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:27 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:16 2010
Message-Id: <20100313002716.230861083@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mitchell Solomon <mitchjs@rush2112.net>
Subject: [126/145] USB: add new ftdi_sio device ids
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Mitchell Solomon <mitchjs@rush2112.net>

commit 9714080d20f2ec4b671a06ce69367d91fa9e227e upstream.

PID patch for my products

Signed-off-by: Mitchell Solomon <mitchjs@rush2112.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |    4 ++++
 drivers/usb/serial/ftdi_sio_ids.h |    8 ++++++++
 2 files changed, 12 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -737,6 +737,10 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
 	{ USB_DEVICE(FTDI_VID, HAMEG_HO870_PID) },
+	{ USB_DEVICE(FTDI_VID, MJSG_GENERIC_PID) },
+	{ USB_DEVICE(FTDI_VID, MJSG_SR_RADIO_PID) },
+	{ USB_DEVICE(FTDI_VID, MJSG_HD_RADIO_PID) },
+	{ USB_DEVICE(FTDI_VID, MJSG_XM_RADIO_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1002,3 +1002,11 @@
 #define EVO_8U232AM_PID	0x02FF	/* Evolution robotics RCM2 (FT232AM)*/
 #define EVO_HYBRID_PID		0x0302	/* Evolution robotics RCM4 PID (FT232BM)*/
 #define EVO_RCM4_PID		0x0303	/* Evolution robotics RCM4 PID */
+
+/*
+ * MJS Gadgets HD Radio / XM Radio / Sirius Radio interfaces (using VID 0x0403)
+ */
+#define MJSG_GENERIC_PID	0x9378
+#define MJSG_SR_RADIO_PID	0x9379
+#define MJSG_XM_RADIO_PID	0x937A
+#define MJSG_HD_RADIO_PID	0x937C


