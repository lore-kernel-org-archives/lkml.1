Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbYLKTlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbYLKTlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbYLKTTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:15 -0500
Received: from kroah.org ([198.145.64.141]:56606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756767AbYLKTTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:14 -0500
Date: Thu, 11 Dec 2008 11:16:11 -0800
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 64/83] ALSA: emu10k1 - Add more invert_shared_spdif flag to
	Audigy models
Message-ID: <20081211191611.GL5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-emu10k1-add-more-invert_shared_spdif-flag-to-audigy-models.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 55e03a68d2489d116a5c5e8111ecef3f69831ed6 upstream.

Reported in Novell bnc#440862:
    https://bugzilla.novell.com/show_bug.cgi?id=440862

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/emu10k1/emu10k1_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1464,6 +1464,7 @@ static struct snd_emu_chip_details emu_c
 	 .ca0151_chip = 1,
 	 .spk71 = 1,
 	 .spdif_bug = 1,
+	 .invert_shared_spdif = 1,	/* digital/analog switch swapped */
 	 .ac97_chip = 1} ,
 	{.vendor = 0x1102, .device = 0x0004, .subsystem = 0x20021102,
 	 .driver = "Audigy2", .name = "Audigy 2 ZS [SB0350]", 
@@ -1473,6 +1474,7 @@ static struct snd_emu_chip_details emu_c
 	 .ca0151_chip = 1,
 	 .spk71 = 1,
 	 .spdif_bug = 1,
+	 .invert_shared_spdif = 1,	/* digital/analog switch swapped */
 	 .ac97_chip = 1} ,
 	{.vendor = 0x1102, .device = 0x0004, .subsystem = 0x20011102,
 	 .driver = "Audigy2", .name = "Audigy 2 ZS [2001]", 
@@ -1482,6 +1484,7 @@ static struct snd_emu_chip_details emu_c
 	 .ca0151_chip = 1,
 	 .spk71 = 1,
 	 .spdif_bug = 1,
+	 .invert_shared_spdif = 1,	/* digital/analog switch swapped */
 	 .ac97_chip = 1} ,
 	/* Audigy 2 */
 	/* Tested by James@superbug.co.uk 3rd July 2005 */

