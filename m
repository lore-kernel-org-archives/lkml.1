Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936484Ab0CMB2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:28:25 -0500
Received: from kroah.org ([198.145.64.141]:60712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934901Ab0CMAUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:04 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001508.852502833@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 042/123] ALSA: hda: Use 3stack quirk for Toshiba Satellite L40-10Q
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit ba579eb7b30791751f556ee01905636cda50c864 upstream.

BugLink: https://bugs.launchpad.net/bugs/524948

The OR has verified that the existing model=laptop-eapd quirk does not
function correctly but instead needs model=3stack.  Make this change
so that manual corrections to module-init-tools file(s) are not
required.

Reported-by: Lasse Havelund <lasse@havelund.org>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1008,7 +1008,7 @@ static struct snd_pci_quirk ad1986a_cfg_
 	SND_PCI_QUIRK(0x1043, 0x81cb, "ASUS M2N", AD1986A_3STACK),
 	SND_PCI_QUIRK(0x1043, 0x8234, "ASUS M2N", AD1986A_3STACK),
 	SND_PCI_QUIRK(0x10de, 0xcb84, "ASUS A8N-VM", AD1986A_3STACK),
-	SND_PCI_QUIRK(0x1179, 0xff40, "Toshiba", AD1986A_LAPTOP_EAPD),
+	SND_PCI_QUIRK(0x1179, 0xff40, "Toshiba Satellite L40-10Q", AD1986A_3STACK),
 	SND_PCI_QUIRK(0x144d, 0xb03c, "Samsung R55", AD1986A_3STACK),
 	SND_PCI_QUIRK(0x144d, 0xc01e, "FSC V2060", AD1986A_LAPTOP),
 	SND_PCI_QUIRK(0x144d, 0xc024, "Samsung P50", AD1986A_SAMSUNG_P50),


