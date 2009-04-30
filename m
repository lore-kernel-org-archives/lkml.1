Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbZD3R2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbZD3R2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764592AbZD3RIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:04 -0400
Received: from kroah.org ([198.145.64.141]:56585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764580AbZD3RHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:45 2009
Message-Id: <20090430165745.176874157@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Korsgaard <jacmet@sunsite.dk>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 46/88] USB: ftdi_sio: add vendor/project id for JETI specbos 1201 spectrometer
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0078-USB-ftdi_sio-add-vendor-project-id-for-JETI-specbo.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

upstream commit: ae27d84351f1f3568118318a8c40ff3a154bd629

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -665,6 +665,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -901,6 +901,13 @@
 #define ADI_GNICE_PID 		0xF000
 
 /*
+ * JETI SPECTROMETER SPECBOS 1201
+ * http://www.jeti.com/products/sys/scb/scb1201.php
+ */
+#define JETI_VID		0x0c6c
+#define JETI_SPC1201_PID	0x04b2
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0


