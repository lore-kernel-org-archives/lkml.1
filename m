Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbYLKThc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbYLKThc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbYLKTTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:00 -0500
Received: from kroah.org ([198.145.64.141]:56486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757849AbYLKTS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:59 -0500
Date: Thu, 11 Dec 2008 11:15:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Kailang Yang <kailang@realtek.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 54/83] ALSA: hda - Add support of ALC272
Message-ID: <20081211191547.GB5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-support-of-alc272.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 01afd41f55524e8378601dbf33b858d8dd4b3f31 upstream

Added the support of ALC272 codec.  It's almost compatible with ALC663.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -14910,6 +14910,9 @@ static int patch_alc662(struct hda_codec
 	if (codec->vendor_id == 0x10ec0663) {
 		spec->stream_name_analog = "ALC663 Analog";
 		spec->stream_name_digital = "ALC663 Digital";
+	} else if (codec->vendor_id == 0x10ec0272) {
+		spec->stream_name_analog = "ALC272 Analog";
+		spec->stream_name_digital = "ALC272 Digital";
 	} else {
 		spec->stream_name_analog = "ALC662 Analog";
 		spec->stream_name_digital = "ALC662 Digital";
@@ -14947,6 +14950,7 @@ struct hda_codec_preset snd_hda_preset_r
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },
 	{ .id = 0x10ec0268, .name = "ALC268", .patch = patch_alc268 },
 	{ .id = 0x10ec0269, .name = "ALC269", .patch = patch_alc269 },
+	{ .id = 0x10ec0272, .name = "ALC272", .patch = patch_alc662 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },

