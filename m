Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbYGaATf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbYGaATf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762778AbYGaASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:18:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:37143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763066AbYGaASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:18:33 -0400
Date: Wed, 30 Jul 2008 16:59:15 -0700
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
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 39/62] DVB: dib0700: add support for Hauppauge Nova-TD
	Stick 52009
Message-ID: <20080730235915.GM12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-dib0700-add-support-for-hauppauge-nova-td-stick-52009.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Michael Krufky <mkrufky@linuxtv.org>

(cherry picked from commit d01eb2dc7d5265ec3bee9ec1b8ab79155e1310d6)

DVB: dib0700: add support for Hauppauge Nova-TD Stick 52009

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -1117,6 +1117,7 @@ struct usb_device_id dib0700_usb_id_tabl
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_HT_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS) },
 	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
+	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1372,7 +1373,7 @@ struct dvb_usb_device_properties dib0700
 			}
 		},
 
-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{   "DiBcom STK7070PD reference design",
 				{ &dib0700_usb_id_table[17], NULL },
@@ -1381,6 +1382,10 @@ struct dvb_usb_device_properties dib0700
 			{   "Pinnacle PCTV Dual DVB-T Diversity Stick",
 				{ &dib0700_usb_id_table[18], NULL },
 				{ NULL },
+			},
+			{   "Hauppauge Nova-TD Stick (52009)",
+				{ &dib0700_usb_id_table[35], NULL },
+				{ NULL },
 			}
 		}
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -132,6 +132,7 @@
 #define USB_PID_HAUPPAUGE_NOVA_T_STICK_3		0x7070
 #define USB_PID_HAUPPAUGE_MYTV_T			0x7080
 #define USB_PID_HAUPPAUGE_NOVA_TD_STICK			0x9580
+#define USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009		0x5200
 #define USB_PID_AVERMEDIA_EXPRESS			0xb568
 #define USB_PID_AVERMEDIA_VOLAR				0xa807
 #define USB_PID_AVERMEDIA_VOLAR_2			0xb808

-- 
