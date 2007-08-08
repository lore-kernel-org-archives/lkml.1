Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbXHHVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbXHHVw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXHHVwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:52:19 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53392 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbXHHVwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:52:18 -0400
Subject: [PATCH] RCU: Remove prototype for nonexistent function
	synchronize_idle()
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: paulmck@us.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 14:52:53 -0700
Message-Id: <1186609973.2699.57.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize_idle() sounds like an interesting function, but we don't
actually have it, so don't prototype it.  Introduced in commit
9b06e818985d139fd9e82c28297f7744e1b484e1, in 2005.

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 include/linux/rcupdate.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c6b7485..fe17d7d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -281,7 +281,6 @@ extern void FASTCALL(call_rcu(struct rcu_head *head,
 extern void FASTCALL(call_rcu_bh(struct rcu_head *head,
 				void (*func)(struct rcu_head *head)));
 extern void synchronize_rcu(void);
-void synchronize_idle(void);
 extern void rcu_barrier(void);
 
 #endif /* __KERNEL__ */
-- 
1.5.2.1


