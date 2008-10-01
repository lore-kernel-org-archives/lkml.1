Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYJAH5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYJAH5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbYJAH5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:57:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:62119 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYJAH5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:57:34 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH -tip] pcm_native: label out defined but not used
Date: Wed,  1 Oct 2008 00:57:25 -0700
Message-Id: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 sound/core/pcm_native.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c487025..3953bf6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3252,7 +3252,7 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
 	runtime = substream->runtime;
 
 	err = fasync_helper(fd, file, on, &runtime->fasync);
-out:
+
 	unlock_kernel();
 	if (err < 0)
 		return err;
-- 
1.6.0.2

