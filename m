Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0BQSsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:48:54 -0500
Received: from www.tglx.de ([62.245.132.106]:42307 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0BQSsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:48:18 -0500
Message-Id: <20100217184155.809849840@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 18:47:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: [patch 2/5] seqlock: Remove old style init
References: <20100217183740.486724334@linutronix.de>
Content-Disposition: inline; filename=seqlock-remove-oldstyle-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the last users of SEQLOCK_UNLOCKED are gone, remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/seqlock.h |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6-tip/include/linux/seqlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/seqlock.h
+++ linux-2.6-tip/include/linux/seqlock.h
@@ -41,9 +41,6 @@ typedef struct {
 #define __SEQLOCK_UNLOCKED(lockname) \
 		 { 0, __SPIN_LOCK_UNLOCKED(lockname) }
 
-#define SEQLOCK_UNLOCKED \
-		 __SEQLOCK_UNLOCKED(old_style_seqlock_init)
-
 #define seqlock_init(x)					\
 	do {						\
 		(x)->sequence = 0;			\


