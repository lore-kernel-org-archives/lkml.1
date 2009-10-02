Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbZJBBz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbZJBBz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZJBBz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:55:57 -0400
Received: from kroah.org ([198.145.64.141]:33070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625AbZJBBdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:12 2009
Message-Id: <20091002012412.171955216@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rainer Keller <mail@rainerkeller.de>
Subject: [041/136] USB: add PIDs for FTDI based OpenDCC hardware
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-add-pids-for-ftdi-based-opendcc-hardware.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: mail@rainerkeller.de <mail@rainerkeller.de>

commit ec3815c3e14dc68d49428e6505ae99e86e5dd067 upstream.

Some devices from the OpenDCC project are missing in the list
of the FTDI PIDs. These PIDs are listed at
http://www.opendcc.de/elektronik/usb/opendcc_usb.html
(Sorry for the german only page.)
This patch adds the three missing devices.

Signed-off-by: Rainer Keller <mail@rainerkeller.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    3 +++
 drivers/usb/serial/ftdi_sio.h |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -176,6 +176,9 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_MICRO_CHAMELEON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RELAIS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_SNIFFER_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -81,6 +81,9 @@
 
 /* OpenDCC (www.opendcc.de) product id */
 #define FTDI_OPENDCC_PID	0xBFD8
+#define FTDI_OPENDCC_SNIFFER_PID	0xBFD9
+#define FTDI_OPENDCC_THROTTLE_PID	0xBFDA
+#define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 
 /* Sprog II (Andrew Crosland's SprogII DCC interface) */
 #define FTDI_SPROG_II		0xF0C8


