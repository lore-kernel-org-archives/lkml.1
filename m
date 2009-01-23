Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbZAWBR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbZAWBR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760049AbZAWBOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:48 -0500
Received: from kroah.org ([198.145.64.141]:50435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759955AbZAWBOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:47 -0500
Date: Thu, 22 Jan 2009 17:11:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 10/46] ALSA: hda - Add quirk for another HP dv5
Message-ID: <20090123011146.GK19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-quirk-for-another-hp-dv5.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>

commit dafb70ce1026d4d6ef1b16ad6996c9589bb11cce upstream.

Add the model=hp-m4 quirk for another HP dv5 (103c:3603)
Reference: kernel bug#12440
	http://bugzilla.kernel.org/show_bug.cgi?id=12440

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1722,6 +1722,8 @@ static struct snd_pci_quirk stac92hd71bx
 		      "HP dv7", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x30fc,
 		      "HP dv7", STAC_HP_M4),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x3603,
+		      "HP dv5", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x361a,
 				"unknown HP", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0233,

