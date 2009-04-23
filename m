Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbZDWHyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbZDWHyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZDWHd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:59 -0400
Received: from sous-sol.org ([216.99.217.87]:51002 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755830AbZDWHdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:52 -0400
Message-Id: <20090423072923.721843115@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 079/100] USB: ftdi_sio: add vendor/project id for JETI specbos 1201 spectrometer
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=usb-ftdi_sio-add-vendor-project-id-for-jeti-specbos-1201-spectrometer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

upstream commit: ae27d84351f1f3568118318a8c40ff3a154bd629

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -668,6 +668,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -913,6 +913,13 @@
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

