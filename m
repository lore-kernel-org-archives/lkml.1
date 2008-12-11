Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbYLKTfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbYLKTfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbYLKTSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:55 -0500
Received: from kroah.org ([198.145.64.141]:56394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757787AbYLKTSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:52 -0500
Date: Thu, 11 Dec 2008 11:15:19 -0800
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
       Matthew Ranostay <mranostay@embeddedalley.com>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 48/83] ALSA: hda: fixed hp_nid DAC for DELL_M6
Message-ID: <20081211191519.GV5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fixed-hp_nid-dac-for-dell_m6.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Ranostay <mranostay@embeddedalley.com>

commit f7cf0a7ce56eb91752fa441cff2669f8d61d4e5e upstream

This patch sets the HP out not used by the "Headphone to Line Out" switch to the
hp_nid.

Signed-off-by: Matthew Ranostay <mranostay@embeddedalley.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_sigmatel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -548,8 +548,8 @@ static struct hda_verb dell_eq_core_init
 	{ 0x1f, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xec},
 	/* setup audio connections */
 	{ 0x0d, AC_VERB_SET_CONNECT_SEL, 0x00},
-	{ 0x0a, AC_VERB_SET_CONNECT_SEL, 0x01},
-	{ 0x0f, AC_VERB_SET_CONNECT_SEL, 0x02},
+	{ 0x0a, AC_VERB_SET_CONNECT_SEL, 0x02},
+	{ 0x0f, AC_VERB_SET_CONNECT_SEL, 0x01},
 	/* setup adcs to point to mixer */
 	{ 0x20, AC_VERB_SET_CONNECT_SEL, 0x0b},
 	{ 0x21, AC_VERB_SET_CONNECT_SEL, 0x0b},

