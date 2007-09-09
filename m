Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbXIIU1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbXIIU1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbXIIUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:25:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60732 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759492AbXIIUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:25:17 -0400
Date: Sun, 9 Sep 2007 22:25:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] unexport snd_ctl_elem_{read,write}
Message-ID: <20070909202524.GS3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

snd_ctl_elem_{read,write} no longer have any modular users.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 27 Aug 2007

 sound/core/control.c |    4 ----
 1 file changed, 4 deletions(-)

23e15051dde57c569e4c9aff1339aaf64185ea71 
diff --git a/sound/core/control.c b/sound/core/control.c
index 396e98e..6144d8a 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -716,8 +716,6 @@ int snd_ctl_elem_read(struct snd_card *card, struct snd_ctl_elem_value *control)
 	return result;
 }
 
-EXPORT_SYMBOL(snd_ctl_elem_read);
-
 static int snd_ctl_elem_read_user(struct snd_card *card,
 				  struct snd_ctl_elem_value __user *_control)
 {
@@ -781,8 +779,6 @@ int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 	return result;
 }
 
-EXPORT_SYMBOL(snd_ctl_elem_write);
-
 static int snd_ctl_elem_write_user(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_value __user *_control)
 {

