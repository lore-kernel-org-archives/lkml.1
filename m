Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZHXH6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZHXH6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZHXH6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:58:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45643 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbZHXH5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:57:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/7] sunrpc: use lazy workqueues
Date: Mon, 24 Aug 2009 09:56:55 +0200
Message-Id: <1251100616-28604-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 net/sunrpc/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 8f459ab..ce99fe2 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -970,7 +970,7 @@ static int rpciod_start(void)
 	 * Create the rpciod thread and wait for it to start.
 	 */
 	dprintk("RPC:       creating workqueue rpciod\n");
-	wq = create_workqueue("rpciod");
+	wq = create_lazy_workqueue("rpciod");
 	rpciod_workqueue = wq;
 	return rpciod_workqueue != NULL;
 }
-- 
1.6.4.173.g3f189

