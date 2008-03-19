Return-Path: <linux-kernel-owner+w=401wt.eu-S1764717AbYCSWhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764717AbYCSWhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764391AbYCSVJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:09:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936294AbYCSVI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:08:58 -0400
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc32: asm-offsets ptrace cruft
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Clerical quaking rebellions
   (2) Ruminant bracelet yies
   (3) Poppin-Fresh Abrasion winds
   (4) Cagey Cretaceous flakes
   (5) Cubical removers
Message-Id: <20080319210751.C95B126F995@magilla.localdomain>
Date: Wed, 19 Mar 2008 14:07:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These items in asm-offsets.c are not used anywhere.  Remove them.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/asm-offsets.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 4b749c4..e932b43 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -26,8 +26,6 @@
 #ifdef CONFIG_PPC64
 #include <linux/time.h>
 #include <linux/hardirq.h>
-#else
-#include <linux/ptrace.h>
 #endif
 
 #include <asm/io.h>
@@ -60,7 +58,6 @@ int main(void)
 	DEFINE(AUDITCONTEXT, offsetof(struct task_struct, audit_context));
 #else
 	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
-	DEFINE(PTRACE, offsetof(struct task_struct, ptrace));
 #endif /* CONFIG_PPC64 */
 
 	DEFINE(KSP, offsetof(struct thread_struct, ksp));
@@ -80,7 +77,6 @@ int main(void)
 	DEFINE(PGDIR, offsetof(struct thread_struct, pgdir));
 #if defined(CONFIG_4xx) || defined(CONFIG_BOOKE)
 	DEFINE(THREAD_DBCR0, offsetof(struct thread_struct, dbcr0));
-	DEFINE(PT_PTRACED, PT_PTRACED);
 #endif
 #ifdef CONFIG_SPE
 	DEFINE(THREAD_EVR0, offsetof(struct thread_struct, evr[0]));
