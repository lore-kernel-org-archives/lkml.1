Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902Ab0AZXoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0AZXoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711Ab0AZXoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:01 -0500
Received: from kroah.org ([198.145.64.141]:35396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab0AZXn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:29 2010
Message-Id: <20100126233929.414146807@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [65/98] ALSA: hda - Fix quirk for Maxdata obook4-1
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2fef62c825f09e29d2f52dc187ddf6f99e28c7f1 upstream.

Works fine with the auto-parser.

Reference: Novell bnc#564940
	https://bugzilla.novell.com/show_bug.cgi?id=564940

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8839,7 +8839,7 @@ static struct snd_pci_quirk alc882_cfg_t
 	SND_PCI_QUIRK(0x1462, 0x040d, "MSI", ALC883_TARGA_2ch_DIG),
 	SND_PCI_QUIRK(0x1462, 0x0579, "MSI", ALC883_TARGA_2ch_DIG),
 	SND_PCI_QUIRK(0x1462, 0x28fb, "Targa T8", ALC882_TARGA), /* MSI-1049 T8  */
-	SND_PCI_QUIRK(0x1462, 0x2fb3, "MSI", ALC883_TARGA_2ch_DIG),
+	SND_PCI_QUIRK(0x1462, 0x2fb3, "MSI", ALC882_AUTO),
 	SND_PCI_QUIRK(0x1462, 0x6668, "MSI", ALC882_6ST_DIG),
 	SND_PCI_QUIRK(0x1462, 0x3729, "MSI S420", ALC883_TARGA_DIG),
 	SND_PCI_QUIRK(0x1462, 0x3783, "NEC S970", ALC883_TARGA_DIG),


