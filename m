Return-Path: <linux-kernel-owner+w=401wt.eu-S1761728AbZAOUBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761728AbZAOUBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbZAOUAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:16 -0500
Received: from kroah.org ([198.145.64.141]:48686 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757642AbZAOUAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:14 -0500
Date: Thu, 15 Jan 2009 11:57:15 -0800
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
Subject: [patch 02/94] ALSA: hda - Add quirk for HP6730B laptop
Message-ID: <20090115195715.GB14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-quirk-for-hp6730b-laptop.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 11d518e07d700eeb5bcec36bfd5f501e405230dd upstream.

Added model=laptop for HP 6730B laptop with AD1984A codec.
Reference: Novell bnc#457909
	https://bugzilla.novell.com/show_bug.cgi?id=457909

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3861,6 +3861,7 @@ static const char *ad1884a_models[AD1884
 static struct snd_pci_quirk ad1884a_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x3030, "HP", AD1884A_MOBILE),
 	SND_PCI_QUIRK(0x103c, 0x3056, "HP", AD1884A_MOBILE),
+	SND_PCI_QUIRK(0x103c, 0x30e6, "HP 6730b", AD1884A_LAPTOP),
 	SND_PCI_QUIRK(0x103c, 0x30e7, "HP EliteBook 8530p", AD1884A_LAPTOP),
 	SND_PCI_QUIRK(0x103c, 0x3614, "HP 6730s", AD1884A_LAPTOP),
 	SND_PCI_QUIRK(0x17aa, 0x20ac, "Thinkpad X300", AD1884A_THINKPAD),

