Return-Path: <linux-kernel-owner+w=401wt.eu-S1163304AbXD1Rxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163304AbXD1Rxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163321AbXD1Rxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:36 -0400
Received: from mail.suse.de ([195.135.220.2]:34431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163304AbXD1Rwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:47 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [21/35] x86_64: Some cleanup in time.c
Message-Id: <20070428175246.4FB00151F0@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Move prototypes into header files
Remove unneeded includes.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/time.c  |    5 +----
 include/asm-x86_64/proto.h |    2 ++
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -39,13 +39,10 @@
 #include <asm/proto.h>
 #include <asm/hpet.h>
 #include <asm/sections.h>
-#include <linux/cpufreq.h>
 #include <linux/hpet.h>
 #include <asm/apic.h>
 #include <asm/hpet.h>
-
-extern void i8254_timer_resume(void);
-extern int using_apic_timer;
+#include <asm/mpspec.h>
 
 static char *timename = NULL;
 
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -122,6 +122,8 @@ extern void smp_local_timer_interrupt(vo
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
+void i8254_timer_resume(void);
+
 #define round_up(x,y) (((x) + (y) - 1) & ~((y)-1))
 #define round_down(x,y) ((x) & ~((y)-1))
 
