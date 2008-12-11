Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbYLKTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbYLKTik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757860AbYLKTTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:06 -0500
Received: from kroah.org ([198.145.64.141]:56520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756250AbYLKTTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:03 -0500
Date: Thu, 11 Dec 2008 11:15:54 -0800
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
Subject: [patch 57/83] ALSA: hda - Add a quirk for another Acer Aspire
	(1025:0090)
Message-ID: <20081211191554.GE5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-a-quirk-for-another-acer-aspire.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 69e50282b726bab75c8050c4836dc89b7eb7bf1a upstream

Added a quirk for another Acer Aspier laptop (1025:0090) with ALC883
codec.  Reported in Novell bnc#426935:
    https://bugzilla.novell.com/show_bug.cgi?id=426935

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8013,6 +8013,7 @@ static const char *alc883_models[ALC883_
 static struct snd_pci_quirk alc883_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1019, 0x6668, "ECS", ALC883_3ST_6ch_DIG),
 	SND_PCI_QUIRK(0x1025, 0x006c, "Acer Aspire 9810", ALC883_ACER_ASPIRE),
+	SND_PCI_QUIRK(0x1025, 0x0090, "Acer Aspire", ALC883_ACER_ASPIRE),
 	SND_PCI_QUIRK(0x1025, 0x0110, "Acer Aspire", ALC883_ACER_ASPIRE),
 	SND_PCI_QUIRK(0x1025, 0x0112, "Acer Aspire 9303", ALC883_ACER_ASPIRE),
 	SND_PCI_QUIRK(0x1025, 0x0121, "Acer Aspire 5920G", ALC883_ACER_ASPIRE), 

