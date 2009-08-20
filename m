Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZHTKTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZHTKTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZHTKSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:18:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60178 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZHTKRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:55 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/6] sunrpc: use lazy workqueues
Date: Thu, 20 Aug 2009 12:17:46 +0200
Message-Id: <1250763466-24282-12-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-11-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-6-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-7-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-8-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-9-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-10-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-11-git-send-email-jens.axboe@oracle.com>
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

