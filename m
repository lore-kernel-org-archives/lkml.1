Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYHDVlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYHDVlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765679AbYHDVld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:41:33 -0400
Received: from ns.suse.de ([195.135.220.2]:55230 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1770709AbYHDVlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:41:32 -0400
Date: Mon, 4 Aug 2008 14:30:42 -0700
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [patch 21/25] ALSA: hda - Add missing Thinkpad Z60m support
Message-ID: <20080804213042.GU8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-missing-thinkpad-z60m-support.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 470eaf6be78424fc499a5039e5d5fe58bace2bc3 upstream

Added the missing SSID of Thinkpad Z60m for model=thinkpad with
AD1981HD.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1618,6 +1618,7 @@ static const char *ad1981_models[AD1981_
 
 static struct snd_pci_quirk ad1981_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1014, 0x0597, "Lenovo Z60", AD1981_THINKPAD),
+	SND_PCI_QUIRK(0x1014, 0x05b7, "Lenovo Z60m", AD1981_THINKPAD),
 	/* All HP models */
 	SND_PCI_QUIRK(0x103c, 0, "HP nx", AD1981_HP),
 	SND_PCI_QUIRK(0x1179, 0x0001, "Toshiba U205", AD1981_TOSHIBA),

-- 
