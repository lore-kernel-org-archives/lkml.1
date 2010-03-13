Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935873Ab0CMAvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:51:55 -0500
Received: from kroah.org ([198.145.64.141]:46998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935468Ab0CMAbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:51 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:12 2010
Message-Id: <20100313002712.212273458@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [080/145] ALSA: hda - Add a position_fix quirk for MSI Wind U115
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Takashi Iwai <tiwai@suse.de>

commit 45d4ebf1a6255f2234a041685789cbecac3453f1 upstream.

MSI Wind U115 seems to require position_fix=1 explicitly.
Otherwise it screws up PulseAudio.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2226,6 +2226,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1462, 0x1002, "MSI Wind U115", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1565, 0x820f, "Biostar Microtech", POS_FIX_LPIB),
 	{}
 };


