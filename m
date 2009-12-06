Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZLGAgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZLGAgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbZLGAgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:36:07 -0500
Received: from kroah.org ([198.145.64.141]:34196 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758265AbZLGAMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:42 2009
Message-Id: <20091207000642.574512439@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [013/119] ALSA: hda - Dell Studio 1557 hd-audio quirk
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-dell-studio-1557-hd-audio-quirk.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Daniel J Blueman <daniel.blueman@gmail.com>

commit 8ef5837a47f73faee18fa7ce2f9a9eb7675be8de upstream.

Add the Dell Studio 15 (model 1557, Core i7) laptop to the hd-audio
quirk list, enabling audio.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1817,6 +1817,8 @@ static struct snd_pci_quirk stac92hd73xx
 				"Dell Studio 17", STAC_DELL_M6_DMIC),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02be,
 				"Dell Studio 1555", STAC_DELL_M6_DMIC),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02bd,
+				"Dell Studio 1557", STAC_DELL_M6_DMIC),
 	{} /* terminator */
 };
 


