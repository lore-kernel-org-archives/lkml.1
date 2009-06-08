Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZFHOfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZFHOfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZFHOfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:35:00 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:19374 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607AbZFHOe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:34:58 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KKXCHZ-02-CQI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/5] dma-debug: comment style fixes
Date: Mon, 8 Jun 2009 16:34:06 +0200
Message-ID: <1244471650-4632-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
References: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Jun 2009 14:34:14.0975 (UTC) FILETIME=[3285BCF0:01C9E846]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last patch series introduced some new comment which does not fit the
Kernel comment style guidelines. Fix it with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 77053d9..b8a61ff 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -542,7 +542,8 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 
 	write_lock_irqsave(&driver_name_lock, flags);
 
-	/* Now handle the string we got from userspace very carefully.
+	/*
+	 * Now handle the string we got from userspace very carefully.
 	 * The rules are:
 	 *         - only use the first token we got
 	 *         - token delimiter is everything looking like a space
@@ -551,7 +552,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	 */
 	if (!isalnum(buf[0])) {
 		/*
-		   If the first character userspace gave us is not
+		 * If the first character userspace gave us is not
 		 * alphanumerical then assume the filter should be
 		 * switched off.
 		 */
-- 
1.6.3.1


