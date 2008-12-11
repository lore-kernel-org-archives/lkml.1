Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbYLKTjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbYLKTjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbYLKTTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:08 -0500
Received: from kroah.org ([198.145.64.141]:56543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757854AbYLKTTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:06 -0500
Date: Thu, 11 Dec 2008 11:15:58 -0800
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
       alan@lxorguk.ukuu.org.uk, Michel Marti <mma@objectxp.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 59/83] ALSA: hda - Add another HP model (6730s) for AD1884A
Message-ID: <20081211191558.GG5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-another-hp-model-6730s-for-ad1884a.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michel Marti <mma@objectxp.com>

commit 65b92e5cbc8acd14ea83190b4d016f765dce6075 upstream

Added model=laptop for another HP machine (103c:3614) with AD1884A
codec.

Signed-off-by: Michel Marti <mma@objectxp.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3848,6 +3848,7 @@ static const char *ad1884a_models[AD1884
 static struct snd_pci_quirk ad1884a_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x3030, "HP", AD1884A_MOBILE),
 	SND_PCI_QUIRK(0x103c, 0x3056, "HP", AD1884A_MOBILE),
+	SND_PCI_QUIRK(0x103c, 0x3614, "HP 6730s", AD1884A_LAPTOP),
 	SND_PCI_QUIRK(0x17aa, 0x20ac, "Thinkpad X300", AD1884A_THINKPAD),
 	{}
 };

