Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZKNSUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZKNSUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 13:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZKNST7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 13:19:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:54021 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZKNST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 13:19:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=VVy4D2y4Ds37bTk3eUQAU1/W6xqfba3fVen96NNP6S1s2d9imfiRpS4wLGmPUMdjI8
         KQwJhgMODTZMh3anJtOlsQId+fggi6aatH0rNKj6fhpXLXZ3vlMIrmN7wMRnL2TH5b9k
         jybYC81PyzTN8BKrT8Y0m2999GkumlfIAHGns=
MIME-Version: 1.0
Date: Sat, 14 Nov 2009 18:20:04 +0000
Message-ID: <6278d2220911141020i62a721eg9448a7c8ef08640c@mail.gmail.com>
Subject: [patch] Dell Studio 1557 hd-audio quirk...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Dell Studio 15 (model 1557, Core i7) laptop to the hd-audio
quirk list, enabling audio.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: stable@kernel.org

---
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 6990cfc..285b1e2 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1817,6 +1817,8 @@ static struct snd_pci_quirk stac92hd73xx_cfg_tbl[] = {
 				"Dell Studio 17", STAC_DELL_M6_DMIC),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02be,
 				"Dell Studio 1555", STAC_DELL_M6_DMIC),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02bd,
+				"Dell Studio 1557", STAC_DELL_M6_DMIC),
 	{} /* terminator */
 };

-- 
Daniel J Blueman
