Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbYLKTp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbYLKTp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYLKTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:33 -0500
Received: from kroah.org ([198.145.64.141]:56804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757690AbYLKTTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:31 -0500
Date: Thu, 11 Dec 2008 11:16:41 -0800
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
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 77/83] atv: hid quirk for appletv IR receiver
Message-ID: <20081211191641.GY5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atv-hid-quirk-for-appletv-ir-receiver.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

(2.6.27 backport of 0f492f2a)

Similar to the existing IRCONTROL4 handling

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -83,6 +83,7 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
+#define USB_DEVICE_ID_APPLE_ATV_IRCONTROL	0x8241
 #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
 
 #define USB_VENDOR_ID_ASUS		0x0b05
@@ -458,6 +459,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
 
 	{ USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM, HID_QUIRK_HIDDEV },
+	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
 	{ USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV, HID_QUIRK_HIDINPUT },

