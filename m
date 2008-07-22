Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYGVXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYGVXel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbYGVXXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:53770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163AbYGVXXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:43 -0400
Date: Tue, 22 Jul 2008 16:17:46 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick Boettcher <pb@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ludwig Nussel <lnussel@novell.com>
Subject: [patch 47/47] V4L/DVB (7475): Added support for Terratec Cinergy T
	USB XXS
Message-ID: <20080722231746.GV8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-dvb-added-support-for-terratec-cinergy-t-usb-xxs.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alexander Simon <alexander.simon@informatik.tu-muenchen.de>

commit dc88807ed61ed0fc0d57bd80a92508b9de638f5d upstream.


Alexander Simon found out that the Terratec Cinergy T USB XXS is just a
clone of another DiB7070P-based device.

Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ludwig Nussel <lnussel@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -1062,6 +1062,7 @@ struct usb_device_id dib0700_usb_id_tabl
 /* 30 */{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV73E) },
 	{ USB_DEVICE(USB_VID_YUAN,	USB_PID_YUAN_EC372S) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_HT_EXPRESS) },
+	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1251,7 +1252,7 @@ struct dvb_usb_device_properties dib0700
 			},
 		},
 
-		.num_device_descs = 8,
+		.num_device_descs = 9,
 		.devices = {
 			{   "DiBcom STK7070P reference design",
 				{ &dib0700_usb_id_table[15], NULL },
@@ -1285,6 +1286,10 @@ struct dvb_usb_device_properties dib0700
 				{ &dib0700_usb_id_table[30], NULL },
 				{ NULL },
 			},
+			{   "Terratec Cinergy T USB XXS",
+				{ &dib0700_usb_id_table[33], NULL },
+				{ NULL },
+			},
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -137,6 +137,7 @@
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_HT_USB_XE		0x0058
 #define USB_PID_TERRATEC_CINERGY_HT_EXPRESS		0x0060
+#define USB_PID_TERRATEC_CINERGY_T_XXS			0x0078
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
@@ -191,6 +192,6 @@
 #define USB_PID_GIGABYTE_U7000				0x7001
 #define USB_PID_ASUS_U3000				0x171f
 #define USB_PID_ASUS_U3100				0x173f
-#define  USB_PID_YUAN_EC372S				0x1edc
+#define USB_PID_YUAN_EC372S				0x1edc
 
 #endif

-- 
