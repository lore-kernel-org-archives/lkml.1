Return-Path: <linux-kernel-owner+w=401wt.eu-S1765929AbZAOUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765929AbZAOUAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbZAOUAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:14 -0500
Received: from kroah.org ([198.145.64.141]:48667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753488AbZAOUAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:13 -0500
Date: Thu, 15 Jan 2009 11:57:12 -0800
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
Subject: [patch 01/94] ALSA: hda - Add quirk for another HP dv7
Message-ID: <20090115195712.GA14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-quirk-for-another-hp-dv7.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 69dfaefee4a2dfdfee3488a306403fe1e51f0be5 upstream.

Added the model=hp-m4 quirk for another HP dv7 (103c:30fc) with IDT
92HD71b* codec.

Reference: Novell bnc#461108
	https://bugzilla.novell.com/show_bug.cgi?id=461108

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1720,6 +1720,8 @@ static struct snd_pci_quirk stac92hd71bx
 		      "HP dv5", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x30f4,
 		      "HP dv7", STAC_HP_M4),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x30fc,
+		      "HP dv7", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x361a,
 				"unknown HP", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0233,

