Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbYBGU4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbYBGU4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762449AbYBGUvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:45187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbYBGUvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:12 -0500
Date: Thu, 7 Feb 2008 12:47:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 12/45] USB: ftdi-sio: Patch to add vendor/device id for
	ATK_16IC CCD
Message-ID: <20080207204706.GM16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ftdi-sio-patch-to-add-vendor-device-id-for-atk_16ic-ccd.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Franco Lanza <nextime@nexlab.it>

little patches only to add vendor/device id of ATK_16IC CCD cam for
astronomy.

From: Franco Lanza <nextime@nexlab.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -543,6 +543,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16C_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16HR_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16HRC_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16IC_PID) },
 	{ USB_DEVICE(KOBIL_VID, KOBIL_CONV_B1_PID) },
 	{ USB_DEVICE(KOBIL_VID, KOBIL_CONV_KAAN_PID) },
 	{ USB_DEVICE(POSIFLEX_VID, POSIFLEX_PP7000_PID) },
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -279,6 +279,7 @@
 #define FTDI_ATIK_ATK16C_PID	0xDF32	/* ATIK ATK-16C Colour Camera */
 #define FTDI_ATIK_ATK16HR_PID	0xDF31	/* ATIK ATK-16HR Grayscale Camera */
 #define FTDI_ATIK_ATK16HRC_PID	0xDF33	/* ATIK ATK-16HRC Colour Camera */
+#define FTDI_ATIK_ATK16IC_PID   0xDF35  /* ATIK ATK-16IC Grayscale Camera */
 
 /*
  * Protego product ids

-- 
