Return-Path: <linux-kernel-owner+w=401wt.eu-S934462AbXFFFYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462AbXFFFYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXFFFYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:24:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbXFFFYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:24:21 -0400
Date: Wed, 6 Jun 2007 01:23:06 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: perex@suse.cz, andy@smile.org.ua
Subject: Yet another Uniwill laptop with ALC861 codec
Message-ID: <20070606052306.GA16320@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, perex@suse.cz,
	andy@smile.org.ua
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rediffed version of the patch from ..
http://bugzilla.kernel.org/show_bug.cgi?id=8016
that seems to be lingering for some time.

Original patch by: Andy Shevchenko <andy@smile.org.ua>
Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4776de9..2e6193c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8771,6 +8771,7 @@ static struct snd_pci_quirk alc861_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1179, 0xff00, "Toshiba", ALC861_TOSHIBA),
 	SND_PCI_QUIRK(0x1179, 0xff10, "Toshiba", ALC861_TOSHIBA),
 	SND_PCI_QUIRK(0x1584, 0x9072, "Uniwill m31", ALC861_UNIWILL_M31),
+	SND_PCI_QUIRK(0x1584, 0x9075, "Uniwill", ALC861_UNIWILL_M31),
 	SND_PCI_QUIRK(0x1584, 0x2b01, "Uniwill X40AIx", ALC861_UNIWILL_M31),
 	SND_PCI_QUIRK(0x1849, 0x0660, "Asrock 939SLI32", ALC660_3ST),
 	SND_PCI_QUIRK(0x8086, 0xd600, "Intel", ALC861_3ST),


-- 
http://www.codemonkey.org.uk
