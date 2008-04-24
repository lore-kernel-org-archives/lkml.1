Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYDXPO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYDXPO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbYDXPO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55906 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbYDXPO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:27 -0400
Message-Id: <20080424151353.078762551@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: [patch 03/37] Change Alpha active count bit
Content-Disposition: inline; filename=change-alpha-active-count-bit.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alpha uses the active count bit 31. This patch moves it to 28 so 31 is freed for
nmi count.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: rth@twiddle.net
CC: ink@jurassic.park.msu.ru
---
 include/asm-alpha/thread_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-sched-devel/include/asm-alpha/thread_info.h
===================================================================
--- linux-2.6-sched-devel.orig/include/asm-alpha/thread_info.h	2008-04-24 10:28:41.000000000 -0400
+++ linux-2.6-sched-devel/include/asm-alpha/thread_info.h	2008-04-24 10:30:22.000000000 -0400
@@ -57,7 +57,7 @@ register struct thread_info *__current_t
 
 #endif /* __ASSEMBLY__ */
 
-#define PREEMPT_ACTIVE		0x40000000
+#define PREEMPT_ACTIVE		0x10000000
 
 /*
  * Thread information flags:

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
