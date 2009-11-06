Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbZKFWnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbZKFWnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbZKFWnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:43:00 -0500
Received: from www.tglx.de ([62.245.132.106]:54112 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933250AbZKFWm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:42:29 -0500
Message-Id: <20091106223807.013213923@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:42:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Chris Zankel <chris@zankel.net>
Subject: [patch 15/16] xtensa: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=xtensa-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/include/asm/rwsem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
+++ linux-2.6/arch/xtensa/include/asm/rwsem.h
@@ -38,7 +38,7 @@ struct rw_semaphore {
 };
 
 #define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
 	  LIST_HEAD_INIT((name).wait_list) }
 
 #define DECLARE_RWSEM(name)		\


