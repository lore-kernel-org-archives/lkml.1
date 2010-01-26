Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801Ab0A0AEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0A0AEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762Ab0A0AEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:04:39 -0500
Received: from kroah.org ([198.145.64.141]:35135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab0AZXnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:23 2010
Message-Id: <20100126233923.095146079@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cliff Brake <cbrake@bec-systems.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [17/98] USB: ftdi_sio: add USB device IDs for B&B Electronics line
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Brake <cbrake@bec-systems.com>

commit a8cbd90a0410096e152f68a4e114a8b5c7abb49b upstream.

Reviewed-by: John Pilles <jpilles@bb-elec.com>
Signed-off-by: Cliff Brake <cbrake@bec-systems.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |   14 ++++++++++++++
 drivers/usb/serial/ftdi_sio.h |   14 ++++++++++++++
 2 files changed, 28 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -598,6 +598,20 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_USOPTL4_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_USPTL4_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2DR_2_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2DR_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_USOPTL4DR2_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_USOPTL4DR_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_485USB9F_2W_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_485USB9F_4W_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_232USB9M_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_485USBTB_2W_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_485USBTB_4W_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_TTL5USB9M_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_TTL3USB9M_PID) },
+	{ USB_DEVICE(BANDB_VID, BANDB_ZZ_PROG1_USB_PID) },
 	{ USB_DEVICE(FTDI_VID, EVER_ECO_PRO_CDS) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_2_PID) },
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -662,6 +662,20 @@
 #define BANDB_USOTL4_PID	0xAC01	/* USOTL4 Isolated RS-485 Converter */
 #define BANDB_USTL4_PID		0xAC02	/* USTL4 RS-485 Converter */
 #define BANDB_USO9ML2_PID	0xAC03	/* USO9ML2 Isolated RS-232 Converter */
+#define BANDB_USOPTL4_PID	0xAC11
+#define BANDB_USPTL4_PID	0xAC12
+#define BANDB_USO9ML2DR_2_PID	0xAC16
+#define BANDB_USO9ML2DR_PID	0xAC17
+#define BANDB_USOPTL4DR2_PID	0xAC18	/* USOPTL4R-2 2-port Isolated RS-232 Converter */
+#define BANDB_USOPTL4DR_PID	0xAC19
+#define BANDB_485USB9F_2W_PID	0xAC25
+#define BANDB_485USB9F_4W_PID	0xAC26
+#define BANDB_232USB9M_PID	0xAC27
+#define BANDB_485USBTB_2W_PID	0xAC33
+#define BANDB_485USBTB_4W_PID	0xAC34
+#define BANDB_TTL5USB9M_PID	0xAC49
+#define BANDB_TTL3USB9M_PID	0xAC50
+#define BANDB_ZZ_PROG1_USB_PID	0xBA02
 
 /*
  * RM Michaelides CANview USB (http://www.rmcan.com)


