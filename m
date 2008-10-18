Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYJRTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYJRTT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYJRTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:47824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYJRTFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:47 -0400
Date: Sat, 18 Oct 2008 11:48:29 -0700
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
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 26/26] DVB: au0828: add support for another USB id for
	Hauppauge HVR950Q
Message-ID: <20081018184829.GA301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-au0828-add-support-for-another-usb-id-for-hauppauge-hvr950q.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Michael Krufky <mkrufky@linuxtv.org>

(cherry picked from commit a636da6bab3307fc8c6e6a22a63b0b25ba0687be)

DVB: au0828: add support for another USB id for Hauppauge HVR950Q

Add autodetection support for a new revision of the Hauppauge HVR950Q (2040:721e)

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/video4linux/CARDLIST.au0828 |    2 +-
 drivers/media/video/au0828/au0828-cards.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/video4linux/CARDLIST.au0828
+++ b/Documentation/video4linux/CARDLIST.au0828
@@ -1,4 +1,4 @@
   0 -> Unknown board                            (au0828)
-  1 -> Hauppauge HVR950Q                        (au0828)        [2040:7200,2040:7210,2040:7217,2040:721b,2040:721f,2040:7280,0fd9:0008]
+  1 -> Hauppauge HVR950Q                        (au0828)        [2040:7200,2040:7210,2040:7217,2040:721b,2040:721e,2040:721f,2040:7280,0fd9:0008]
   2 -> Hauppauge HVR850                         (au0828)        [2040:7240]
   3 -> DViCO FusionHDTV USB                     (au0828)        [0fe9:d620]
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -83,6 +83,7 @@ static void hauppauge_eeprom(struct au08
 	case 72221: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and basic analog video */
 	case 72231: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and basic analog video */
 	case 72241: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and basic analog video */
+	case 72251: /* WinTV-HVR950q (Retail, IR, ATSC/QAM and basic analog video */
 	case 72301: /* WinTV-HVR850 (Retail, IR, ATSC and basic analog video */
 	case 72500: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */
 		break;
@@ -187,6 +188,8 @@ struct usb_device_id au0828_usb_id_table
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
 	{ USB_DEVICE(0x2040, 0x721b),
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
+	{ USB_DEVICE(0x2040, 0x721e),
+		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
 	{ USB_DEVICE(0x2040, 0x721f),
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
 	{ USB_DEVICE(0x2040, 0x7280),

-- 
