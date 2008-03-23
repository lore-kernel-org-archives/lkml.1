Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYCWIVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYCWIVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbYCWIIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:53 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2263 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759269AbYCWIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:50 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 061/148] include/asm-x86/lguest_hcall.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:36 -0700
Message-Id: <1206259443-13210-62-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/lguest_hcall.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/lguest_hcall.h b/include/asm-x86/lguest_hcall.h
index 758b9a5..743d888 100644
--- a/include/asm-x86/lguest_hcall.h
+++ b/include/asm-x86/lguest_hcall.h
@@ -46,7 +46,7 @@ hcall(unsigned long call,
 {
 	/* "int" is the Intel instruction to trigger a trap. */
 	asm volatile("int $" __stringify(LGUEST_TRAP_ENTRY)
-		       /* The call in %eax (aka "a") might be overwritten */
+		     /* The call in %eax (aka "a") might be overwritten */
 		     : "=a"(call)
 		       /* The arguments are in %eax, %edx, %ebx & %ecx */
 		     : "a"(call), "d"(arg1), "b"(arg2), "c"(arg3)
@@ -62,8 +62,7 @@ hcall(unsigned long call,
 #define LGUEST_IRQS (NR_IRQS < 32 ? NR_IRQS: 32)
 
 #define LHCALL_RING_SIZE 64
-struct hcall_args
-{
+struct hcall_args {
 	/* These map directly onto eax, ebx, ecx, edx in struct lguest_regs */
 	unsigned long arg0, arg2, arg3, arg1;
 };
-- 
1.5.4.rc2

