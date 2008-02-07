Return-Path: <linux-kernel-owner+w=401wt.eu-S934151AbYBGU6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbYBGU6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbYBGUvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:45421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762106AbYBGUv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:28 -0500
Date: Thu, 7 Feb 2008 12:47:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ed Beroset <beroset@mindspring.com>
Subject: [patch 16/45] USB: ftdi driver - add support for optical probe
	device
Message-ID: <20080207204715.GQ16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ftdi-driver-add-support-for-optical-probe-device.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ed Beroset <beroset@mindspring.com>

Added support for the Elster Unicom III Optical Probe.
The device ID has already been added to the usb.ids file.

Signed-off-by: Ed Beroset <beroset@mindspring.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -568,6 +568,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
 	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELSTER_UNICOM_PID) },
 	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_olimex_quirk },
 	{ },					/* Optional parameter entry */
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -536,6 +536,8 @@
 #define OLIMEX_VID			0x15BA
 #define OLIMEX_ARM_USB_OCD_PID		0x0003
 
+/* www.elsterelectricity.com Elster Unicom III Optical Probe */
+#define FTDI_ELSTER_UNICOM_PID		0xE700 /* Product Id */
 
 /*
  * The Mobility Lab (TML)

-- 
