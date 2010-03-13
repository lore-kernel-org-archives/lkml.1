Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935879Ab0CMAwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:52:04 -0500
Received: from kroah.org ([198.145.64.141]:47016 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935465Ab0CMAbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:50 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:12 2010
Message-Id: <20100313002712.033370758@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [078/145] ALSA: hda: Use LPIB for Dell Latitude 131L
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit 9919c7619c52d01e89103bca405cc3d4a2b1ac31 upstream.

BugLink: https://launchpad.net/bugs/530346

The OR has verified that position_fix=1 is necessary to work around
errors on his machine.

Reported-by: Tom Louwrier
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2225,6 +2225,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
 	{}
 };
 


