Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbYLKThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbYLKThA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbYLKTS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:59 -0500
Received: from kroah.org ([198.145.64.141]:56469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757418AbYLKTS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:58 -0500
Date: Thu, 11 Dec 2008 11:15:31 -0800
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
Subject: [patch 53/83] ALSA: hda - Add ALC887 support
Message-ID: <20081211191531.GA5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-alc887-support.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit a385a52925398e53bedf1a8b30a9a3e002569f27 upstream

Added ALC887 support.  It's almost compatible with ALC883/888.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -14965,6 +14965,7 @@ struct hda_codec_preset snd_hda_preset_r
 	{ .id = 0x10ec0885, .rev = 0x100103, .name = "ALC889A",
 	  .patch = patch_alc882 }, /* should be patch_alc883() in future */
 	{ .id = 0x10ec0885, .name = "ALC885", .patch = patch_alc882 },
+	{ .id = 0x10ec0887, .name = "ALC887", .patch = patch_alc883 },
 	{ .id = 0x10ec0888, .name = "ALC888", .patch = patch_alc883 },
 	{ .id = 0x10ec0889, .name = "ALC889", .patch = patch_alc883 },
 	{} /* terminator */

