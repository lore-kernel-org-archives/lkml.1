Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0CFUEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 15:04:06 -0500
Received: from smtp186-pc.aruba.it ([62.149.157.186]:47038 "HELO
	smtp1-pc.aruba.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751374Ab0CFUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 15:04:04 -0500
From: Michele Ballabio <barra_cuda@katamail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda - Add ASRock mobo to MSI blacklist
Date: Sat, 6 Mar 2010 21:06:46 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-mike-1mike; KDE/4.3.5; i686; ; )
Cc: tiwai@suse.de, perex@perex.cz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003062106.47245.barra_cuda@katamail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids a lockup at boot.

Signed-off-by: Michele Ballabio <barra_cuda@katamail.com>
---
 sound/pci/hda/hda_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index ff6da6f..1306193 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2351,6 +2351,7 @@ static void __devinit check_probe_mask(struct azx *chip, int dev)
 static struct snd_pci_quirk msi_black_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
+	SND_PCI_QUIRK(0x1849, 0x0888, "ASRock", 0), /* Athlon64 X2 + nvidia */
 	{}
 };
 
-- 
1.7.0


