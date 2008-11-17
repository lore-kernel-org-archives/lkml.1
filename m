Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYKQPLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYKQPLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQPL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:11:27 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29504 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYKQPL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:11:26 -0500
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] ipc: do not goto to the next line
Date: Mon, 17 Nov 2008 18:10:52 +0300
Message-Id: <1226934652-23028-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 ipc/sem.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 0821224..b91d455 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1216,7 +1216,6 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
 	list_del(&queue.list);
-	goto out_unlock_free;
 
 out_unlock_free:
 	sem_unlock(sma);
-- 
1.5.6.4

