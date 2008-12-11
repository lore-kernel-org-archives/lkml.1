Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbYLKTk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbYLKTk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbYLKTTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:13 -0500
Received: from kroah.org ([198.145.64.141]:56591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757398AbYLKTTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:12 -0500
Date: Thu, 11 Dec 2008 11:16:08 -0800
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
Subject: [patch 63/83] ALSA: hda - mark Dell studio 1535 quirk
Message-ID: <20081211191608.GK5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-mark-dell-studio-1535-quirk.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c65574abad288d7123bd49e7906fa53b7e420239 upstream

Fixed the quirk string for Dell studio 1535 (the product name wasn't
published at the time the patch was made).

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1311,7 +1311,7 @@ static struct snd_pci_quirk stac92hd73xx
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x2668,
 				"DFI LanParty", STAC_92HD73XX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0254,
-				"unknown Dell", STAC_DELL_M6),
+				"Dell Studio 1535", STAC_DELL_M6),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0255,
 				"unknown Dell", STAC_DELL_M6),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0256,

