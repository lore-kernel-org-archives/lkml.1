Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZHMTtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZHMTtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbZHMTtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:49:08 -0400
Received: from kroah.org ([198.145.64.141]:36819 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbZHMTsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:39 2009
Message-Id: <20090813194339.809516126@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 27/28] ALSA: hda - Add missing vmaster initialization for ALC269
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-add-missing-vmaster-initialization-for-alc269.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 100d5eb36ba20dc0b99a17ea2b9800c567bfc3d1 upstream.

Without the initialization of vmaster NID, the dB information got
confused for ALC269 codec.

Reference: Novell bnc#527361
	https://bugzilla.novell.com/show_bug.cgi?id=527361

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -13767,6 +13767,8 @@ static int patch_alc861vd(struct hda_cod
 
 	spec->vmaster_nid = 0x02;
 
+	spec->vmaster_nid = 0x02;
+
 	codec->patch_ops = alc_patch_ops;
 
 	if (board_config == ALC861VD_AUTO)


