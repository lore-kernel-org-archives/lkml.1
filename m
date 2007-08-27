Return-Path: <linux-kernel-owner+w=401wt.eu-S1765860AbXH0VhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765860AbXH0VhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764249AbXH0V2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58848 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765227AbXH0V2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:37 -0400
Date: Mon, 27 Aug 2007 23:28:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] video-buf.c: remove dead code
Message-ID: <20070827212837.GB4121@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes code that was both dead and pointless.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d72841ad9ded136818ab054613ab2f3e027af67f 
diff --git a/drivers/media/video/video-buf.c b/drivers/media/video/video-buf.c
index f6f31e1..87cf89a 100644
--- a/drivers/media/video/video-buf.c
+++ b/drivers/media/video/video-buf.c
@@ -1200,8 +1200,6 @@ videobuf_vm_close(struct vm_area_struct *vma)
 		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 			if (NULL == q->bufs[i])
 				continue;
-			if (q->bufs[i])
-				;
 			if (q->bufs[i]->map != map)
 				continue;
 			q->bufs[i]->map   = NULL;

