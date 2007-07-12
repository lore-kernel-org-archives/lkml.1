Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXGLXvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXGLXvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXGLXvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:51:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59654 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753151AbXGLXvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:51:37 -0400
Date: Fri, 13 Jul 2007 01:52:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/sched.c: remove 2 unused exports
Message-ID: <20070712235211.GS3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused exports:
- EXPORT_SYMBOL(cond_resched_softirq);
- EXPORT_SYMBOL_GPL(__wake_up_sync);

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/sched.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.22-rc6-mm1/kernel/sched.c.old	2007-07-12 03:36:55.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/sched.c	2007-07-12 03:37:15.000000000 +0200
@@ -3517,7 +3517,6 @@
 	__wake_up_common(q, mode, nr_exclusive, sync, NULL);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
 void fastcall complete(struct completion *x)
 {
@@ -4453,7 +4452,6 @@
 	}
 	return 0;
 }
-EXPORT_SYMBOL(cond_resched_softirq);
 
 /**
  * yield - yield the current processor to other threads.

