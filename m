Return-Path: <linux-kernel-owner+w=401wt.eu-S637741AbXDSMKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637741AbXDSMKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993255AbXDSMKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:10:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48768 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993248AbXDSMKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=aznwhxgiMSS9Wga4tF3fvxFV08S7qSz41roisPYDis2hgg7PNsEW1TSPpWRn4F4Oi5daSmPrbfcFVv5mEQ5XenyOunmRNVMqSR9KcDlqmo92COWIZ4hjI5MByEDS8QHZu4HQZ7V14Fueyl7Rb7RxHTFUWi7J6J7agxH+fGNStWs=
Date: Thu, 19 Apr 2007 17:43:03 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>
Cc: Andrw Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [KJ][PATCH]SPIN_LOCK_UNLOCKED cleanup in init_task.h
Message-ID: <20070419121303.GB12373@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead 

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
---
 init_task.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index a2d95ff..7951023 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -138,7 +138,7 @@ extern struct group_info init_groups;
 	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
-	.pi_lock	= SPIN_LOCK_UNLOCKED,				\
+	.pi_lock	= __SPIN_LOCK_UNLOCKED(tsk.pi_lock),		\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 }
-- 
Milind Arun Choudhary
