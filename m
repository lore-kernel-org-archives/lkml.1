Return-Path: <linux-kernel-owner+w=401wt.eu-S1946553AbXBIQsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946553AbXBIQsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946659AbXBIQsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:48:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51659 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946628AbXBIQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:11 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] arch/ia64: ansify
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlG-0006kM-K1@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kernel/crash.c |    2 +-
 arch/ia64/kernel/smp.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index 9d92097..37bb16f 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -52,7 +52,7 @@ extern void ia64_dump_cpu_regs(void *);
 static DEFINE_PER_CPU(struct elf_prstatus, elf_prstatus);
 
 void
-crash_save_this_cpu()
+crash_save_this_cpu(void)
 {
 	void *buf;
 	unsigned long cfm, sof, sol;
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index f4c7f77..55ddd80 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -221,13 +221,13 @@ send_IPI_self (int op)
 
 #ifdef CONFIG_KEXEC
 void
-kdump_smp_send_stop()
+kdump_smp_send_stop(void)
 {
  	send_IPI_allbutself(IPI_KDUMP_CPU_STOP);
 }
 
 void
-kdump_smp_send_init()
+kdump_smp_send_init(void)
 {
 	unsigned int cpu, self_cpu;
 	self_cpu = smp_processor_id();
-- 
1.5.0-rc2.GIT


