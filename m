Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbXJ0UUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbXJ0UUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXJ0UUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:20:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56355 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbXJ0UUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:20:03 -0400
Date: Sat, 27 Oct 2007 21:20:02 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] duplicate initializer in sound/pci/hda/patch_realtek.c
Message-ID: <20071027202002.GT8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d9f78c8..1c50278 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9299,7 +9299,6 @@ static struct alc_config_preset alc268_presets[] = {
 		.num_channel_mode = ARRAY_SIZE(alc268_modes),
 		.channel_mode = alc268_modes,
 		.input_mux = &alc268_capture_source,
-		.input_mux = &alc268_capture_source,
 		.unsol_event = alc268_toshiba_unsol_event,
 		.init_hook = alc268_toshiba_automute,
 	},
