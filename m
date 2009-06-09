Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbZFIKbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbZFIKbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbZFIKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:47 -0400
Received: from kroah.org ([198.145.64.141]:55223 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbZFIKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:46 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:05 2009
Message-Id: <20090609094105.665209956@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:46 -0700
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
       alan@lxorguk.ukuu.org.uk, Adam Williamson <awilliam@redhat.com>,
       Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 58/87] ALSA: hda - fix audio on HP TX25xx series notebooks
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=alsa-hda-fix-audio-on-hp-tx25xx-series-notebooks.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Williamson <awilliam@redhat.com>

commit 87488957a68293357a94c8142de7d0ae17914912 upstream.

Fixes https://bugtrack.alsa-project.org/alsa-bug/view.php?id=4121

Taken from https://bugzilla.redhat.com/show_bug.cgi?id=498060

Signed-off-by: Adam Williamson <awilliam@redhat.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11710,6 +11710,7 @@ static struct snd_pci_quirk alc268_cfg_t
 	SND_PCI_QUIRK(0x1028, 0x0253, "Dell OEM", ALC268_DELL),
 	SND_PCI_QUIRK(0x1028, 0x02b0, "Dell Inspiron Mini9", ALC268_DELL),
 	SND_PCI_QUIRK(0x103c, 0x30cc, "TOSHIBA", ALC268_TOSHIBA),
+	SND_PCI_QUIRK(0x103c, 0x30f1, "HP TX25xx series", ALC268_TOSHIBA),
 	SND_PCI_QUIRK(0x1043, 0x1205, "ASUS W7J", ALC268_3ST),
 	SND_PCI_QUIRK(0x1179, 0xff10, "TOSHIBA A205", ALC268_TOSHIBA),
 	SND_PCI_QUIRK(0x1179, 0xff50, "TOSHIBA A305", ALC268_TOSHIBA),


