Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbZBKAhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbZBKAhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbZBKA2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:33 -0500
Received: from kroah.org ([198.145.64.141]:51292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757722AbZBKA2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:30 -0500
Date: Tue, 10 Feb 2009 16:25:13 -0800
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
Subject: [patch 28/56] ALSA: hda - Add missing COEF initialization for
	ALC887
Message-ID: <20090211002513.GC14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-missing-coef-initialization-for-alc887.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4a5a4c56b443a213fa9c2ad27984a8681a3d7087 upstream.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -948,6 +948,7 @@ do_sku:
 		case 0x10ec0882:
 		case 0x10ec0883:
 		case 0x10ec0885:
+		case 0x10ec0887:
 		case 0x10ec0889:
 			snd_hda_codec_write(codec, 0x20, 0,
 					    AC_VERB_SET_COEF_INDEX, 7);

