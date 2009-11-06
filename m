Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbZKFWmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbZKFWmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933248AbZKFWm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:42:29 -0500
Received: from www.tglx.de ([62.245.132.106]:54106 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbZKFWmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:42:25 -0500
Message-Id: <20091106223806.933145642@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:42:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [patch 13/16] sh: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=sh-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/include/asm/rwsem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/sh/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/rwsem.h
+++ linux-2.6/arch/sh/include/asm/rwsem.h
@@ -41,7 +41,7 @@ struct rw_semaphore {
 #endif
 
 #define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
 	  LIST_HEAD_INIT((name).wait_list) \
 	  __RWSEM_DEP_MAP_INIT(name) }
 


