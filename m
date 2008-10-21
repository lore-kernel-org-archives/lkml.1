Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYJUOQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYJUOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYJUOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:16:51 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:59288 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYJUOQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:16:51 -0400
Date: Tue, 21 Oct 2008 22:16:47 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: cl@linux-foundation.org
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fork.c: fix a problem of code style
Message-ID: <20081021141647.GA12090@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix a problem of code style

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 30de644..b6e5a94 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -187,7 +187,7 @@ void __init fork_init(unsigned long mempages)
 	/*
 	 * we need to allow at least 20 threads to boot a system
 	 */
-	if(max_threads < 20)
+	if (max_threads < 20)
 		max_threads = 20;
 
 	init_task.signal->rlim[RLIMIT_NPROC].rlim_cur = max_threads/2;
-- 
1.5.2.5

-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
