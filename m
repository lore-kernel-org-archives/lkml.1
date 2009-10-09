Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbZJIXVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbZJIXVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761579AbZJIXQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:16:50 -0400
Received: from kroah.org ([198.145.64.141]:36737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZJIXQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:16:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:00 2009
Message-Id: <20091009231000.609618671@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Manoj Iyer <manoj.iyer@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 04/26] ALSA: hda - Added quirk to enable sound on Toshiba NB200
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-added-quirk-to-enable-sound-on-toshiba-nb200.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Manoj Iyer <manoj.iyer@canonical.com>

commit 3db6c037c6954ed6d98ef199938e4004fea96908 upstream.

Patch was tested on Toshiba NB200 and is found to enable sound.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -16876,6 +16876,7 @@ static struct snd_pci_quirk alc662_cfg_t
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_ECS),
 	SND_PCI_QUIRK(0x105b, 0x0d47, "Foxconn 45CMX/45GMX/45CMX-K",
 		      ALC662_3ST_6ch_DIG),
+	SND_PCI_QUIRK(0x1179, 0xff6e, "Toshiba NB200", ALC663_ASUS_MODE4),
 	SND_PCI_QUIRK(0x144d, 0xca00, "Samsung NC10", ALC272_SAMSUNG_NC10),
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte 945GCM-S2L",
 		      ALC662_3ST_6ch_DIG),


