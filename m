Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823Ab0AZXoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0AZXoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747Ab0AZXn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:58 -0500
Received: from kroah.org ([198.145.64.141]:35405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0AZXn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:29 2010
Message-Id: <20100126233929.283076170@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wu Fengguang <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [64/98] ALSA: hda - select IbexPeak handler for Calpella
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 739b47f1e5aa3b36eadd7906cc6b41f0175c6ed1 upstream.

An earlier patch merely adds id for 0x80862804.
It has 2/3 cvt/pin nodes and shall be tied to the IbexPeak handler.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_intelhdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_intelhdmi.c
+++ b/sound/pci/hda/patch_intelhdmi.c
@@ -684,7 +684,7 @@ static struct hda_codec_preset snd_hda_p
 	{ .id = 0x80862801, .name = "G45 DEVBLC", .patch = patch_intel_hdmi },
 	{ .id = 0x80862802, .name = "G45 DEVCTG", .patch = patch_intel_hdmi },
 	{ .id = 0x80862803, .name = "G45 DEVELK", .patch = patch_intel_hdmi },
-	{ .id = 0x80862804, .name = "G45 DEVIBX", .patch = patch_intel_hdmi },
+	{ .id = 0x80862804, .name = "G45 DEVIBX", .patch = patch_intel_hdmi_ibexpeak },
 	{ .id = 0x80860054, .name = "Q57 DEVIBX", .patch = patch_intel_hdmi_ibexpeak },
 	{ .id = 0x10951392, .name = "SiI1392 HDMI",     .patch = patch_intel_hdmi },
 	{} /* terminator */


