Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbYCWIv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbYCWIv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbYCWILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:39 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2339 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758081AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 031/148] include/asm-x86/edac.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:06 -0700
Message-Id: <1206259443-13210-32-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/edac.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/edac.h b/include/asm-x86/edac.h
index cf3200a..a8088f6 100644
--- a/include/asm-x86/edac.h
+++ b/include/asm-x86/edac.h
@@ -3,7 +3,7 @@
 
 /* ECC atomic, DMA, SMP and interrupt safe scrub function */
 
-static __inline__ void atomic_scrub(void *va, u32 size)
+static inline void atomic_scrub(void *va, u32 size)
 {
 	u32 i, *virt_addr = va;
 
@@ -12,7 +12,7 @@ static __inline__ void atomic_scrub(void *va, u32 size)
 	 * are interrupt, DMA and SMP safe.
 	 */
 	for (i = 0; i < size / 4; i++, virt_addr++)
-		__asm__ __volatile__("lock; addl $0, %0"::"m"(*virt_addr));
+		asm volatile("lock; addl $0, %0"::"m" (*virt_addr));
 }
 
 #endif
-- 
1.5.4.rc2

