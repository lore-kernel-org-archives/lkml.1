Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbZGABBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbZGABBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbZGAAe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:58 -0400
Received: from kroah.org ([198.145.64.141]:60407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbZGAAe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:29 2009
Message-Id: <20090701002429.681512248@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 053/108] ALSA: hda - Add quirk for Sony VAIO Z21MN
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-add-quirk-for-sony-vaio-z21mn.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 376b508ffde3b17e105265f89b83bdb044b1c1ae upstream.

It needs model=toshiba-s06 to work with the digital-mic.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10915,6 +10915,7 @@ static struct snd_pci_quirk alc262_cfg_t
 	SND_PCI_QUIRK(0x104d, 0x8203, "Sony UX-90", ALC262_HIPPO),
 	SND_PCI_QUIRK(0x104d, 0x820f, "Sony ASSAMD", ALC262_SONY_ASSAMD),
 	SND_PCI_QUIRK(0x104d, 0x9016, "Sony VAIO", ALC262_AUTO), /* dig-only */
+	SND_PCI_QUIRK(0x104d, 0x9025, "Sony VAIO Z21MN", ALC262_TOSHIBA_S06),
 	SND_PCI_QUIRK_MASK(0x104d, 0xff00, 0x9000, "Sony VAIO",
 			   ALC262_SONY_ASSAMD),
 	SND_PCI_QUIRK(0x1179, 0x0001, "Toshiba dynabook SS RX1",


