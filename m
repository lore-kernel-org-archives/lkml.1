Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbZAWGUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbZAWGUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760871AbZAWGQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:31 -0500
Received: from kroah.org ([198.145.64.141]:36184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760853AbZAWGQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:30 -0500
Date: Thu, 22 Jan 2009 22:13:31 -0800
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
       alan@lxorguk.ukuu.org.uk, Luke Yelavich <themuso@ubuntu.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 11/40] ALSA: hda - Add automatic model setting for Samsung
	Q45
Message-ID: <20090123061330.GK2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-automatic-model-setting-for-samsung-q45.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luke Yelavich <themuso@ubuntu.com>

commit 3e420e78ece6f9d2accc1568e80dfd0501e13df1 upstream.

Have the Samsung Q45 (144d:c510) select ALC262_HIPPO by default

Reference: Ubuntu bug 200210
	http://launchpad.net/bugs/200210

Signed-off-by: Luke Yelavich <themuso@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9882,6 +9882,7 @@ static struct snd_pci_quirk alc262_cfg_t
 	SND_PCI_QUIRK(0x10cf, 0x142d, "Fujitsu Lifebook E8410", ALC262_FUJITSU),
 	SND_PCI_QUIRK(0x144d, 0xc032, "Samsung Q1 Ultra", ALC262_ULTRA),
 	SND_PCI_QUIRK(0x144d, 0xc039, "Samsung Q1U EL", ALC262_ULTRA),
+	SND_PCI_QUIRK(0x144d, 0xc510, "Samsung Q45", ALC262_HIPPO),
 	SND_PCI_QUIRK(0x17aa, 0x384e, "Lenovo 3000 y410", ALC262_LENOVO_3000),
 	SND_PCI_QUIRK(0x17ff, 0x0560, "Benq ED8", ALC262_BENQ_ED8),
 	SND_PCI_QUIRK(0x17ff, 0x058d, "Benq T31-16", ALC262_BENQ_T31),

