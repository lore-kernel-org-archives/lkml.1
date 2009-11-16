Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZKPETA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZKPETA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZKPES6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:58 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64232 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZKPES5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JvYfwvQFpdAUAk41ZujcOIEnIku8frkH7Gv868qHMnW8xGmeMIuimZkvJFaF6FcZQQ
         zhP+8Nlv3M+glFSMMFaWcQrq4EJdDOCUBJmQBa/lttSPw/9kILQ3ByuXYHDnrIP5RTvR
         Gpzes1S7EDcRwEQc7U7jtU4Ws0BfhFe+pejQg=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 08/13] staging: line6: Fix checkpatch warnings in pcm.c
Date: Sun, 15 Nov 2009 22:17:57 -0600
Message-Id: <1258345082-11811-9-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/pcm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index fc4113f..dd98121 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -156,7 +156,8 @@ static int snd_line6_new_pcm(struct snd_line6_pcm *line6pcm)
 	strcpy(pcm->name, line6pcm->line6->properties->name);
 
 	/* set operators */
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_line6_playback_ops);
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
+			&snd_line6_playback_ops);
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_line6_capture_ops);
 
 	/* pre-allocation of buffers */
-- 
1.6.5

