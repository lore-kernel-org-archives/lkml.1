Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbZBKAiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbZBKAiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbZBKA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:34 -0500
Received: from kroah.org ([198.145.64.141]:51297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757734AbZBKA2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:30 -0500
Date: Tue, 10 Feb 2009 16:25:15 -0800
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
Subject: [patch 29/56] ALSA: hda - Add missing initialization for ALC272
Message-ID: <20090211002515.GD14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-missing-initialization-for-alc272.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Takashi Iwai <tiwai@suse.de>

commit c6e8f2daadc6d61a32b7486a1058c8f1f9baa499 upstream.

ALC272 needs EAPD for speaker outputs as well as other similar ALC
codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -920,6 +920,7 @@ do_sku:
 		case 0x10ec0267:
 		case 0x10ec0268:
 		case 0x10ec0269:
+		case 0x10ec0272:
 		case 0x10ec0660:
 		case 0x10ec0662:
 		case 0x10ec0663:

