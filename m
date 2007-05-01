Return-Path: <linux-kernel-owner+w=401wt.eu-S1946500AbXEAD6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946500AbXEAD6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946505AbXEAD6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:58:39 -0400
Received: from ns.suse.de ([195.135.220.2]:60963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933498AbXEAD60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:26 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: jan.kiszka@web.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [27/30] i386: white space fixes in i387.h
Message-Id: <20070501035825.E36D815146@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jan Kiszka <jan.kiszka@web.de>

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/i387.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/include/asm-i386/i387.h
===================================================================
--- linux.orig/include/asm-i386/i387.h
+++ linux/include/asm-i386/i387.h
@@ -83,8 +83,8 @@ static inline void __save_init_fpu( stru
 
 #define __clear_fpu( tsk )					\
 do {								\
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {		\
-		asm volatile("fnclex ; fwait");				\
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {	\
+		asm volatile("fnclex ; fwait");			\
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;	\
 		stts();						\
 	}							\
@@ -113,7 +113,7 @@ static inline void save_init_fpu( struct
 	__clear_fpu( tsk );	\
 	preempt_enable();	\
 } while (0)
-					\
+
 /*
  * FPU state interaction...
  */
