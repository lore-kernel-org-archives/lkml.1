Return-Path: <linux-kernel-owner+w=401wt.eu-S1765861AbYCWIpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765861AbYCWIpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759380AbYCWILC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:02 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2318 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbYCWIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:55 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 060/148] include/asm-x86/kvm_x86_emulate.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:35 -0700
Message-Id: <1206259443-13210-61-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/kvm_x86_emulate.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/asm-x86/kvm_x86_emulate.h b/include/asm-x86/kvm_x86_emulate.h
index 7db91b9..d6337f9 100644
--- a/include/asm-x86/kvm_x86_emulate.h
+++ b/include/asm-x86/kvm_x86_emulate.h
@@ -68,10 +68,10 @@ struct x86_emulate_ops {
 	 *  @val:   [OUT] Value read from memory, zero-extended to 'u_long'.
 	 *  @bytes: [IN ] Number of bytes to read from memory.
 	 */
-	int (*read_emulated) (unsigned long addr,
-			      void *val,
-			      unsigned int bytes,
-			      struct kvm_vcpu *vcpu);
+	int (*read_emulated)(unsigned long addr,
+			     void *val,
+			     unsigned int bytes,
+			     struct kvm_vcpu *vcpu);
 
 	/*
 	 * write_emulated: Read bytes from emulated/special memory area.
@@ -80,10 +80,10 @@ struct x86_emulate_ops {
 	 *                required).
 	 *  @bytes: [IN ] Number of bytes to write to memory.
 	 */
-	int (*write_emulated) (unsigned long addr,
-			       const void *val,
-			       unsigned int bytes,
-			       struct kvm_vcpu *vcpu);
+	int (*write_emulated)(unsigned long addr,
+			      const void *val,
+			      unsigned int bytes,
+			      struct kvm_vcpu *vcpu);
 
 	/*
 	 * cmpxchg_emulated: Emulate an atomic (LOCKed) CMPXCHG operation on an
@@ -93,11 +93,11 @@ struct x86_emulate_ops {
 	 *  @new:   [IN ] Value to write to @addr.
 	 *  @bytes: [IN ] Number of bytes to access using CMPXCHG.
 	 */
-	int (*cmpxchg_emulated) (unsigned long addr,
-				 const void *old,
-				 const void *new,
-				 unsigned int bytes,
-				 struct kvm_vcpu *vcpu);
+	int (*cmpxchg_emulated)(unsigned long addr,
+				const void *old,
+				const void *new,
+				unsigned int bytes,
+				struct kvm_vcpu *vcpu);
 
 };
 
@@ -143,7 +143,7 @@ struct x86_emulate_ctxt {
 	/* Register state before/after emulation. */
 	struct kvm_vcpu *vcpu;
 
-	/* Linear faulting address (if emulating a page-faulting instruction). */
+	/* Linear faulting address (if emulating a page-faulting instruction) */
 	unsigned long eflags;
 
 	/* Emulated execution mode, represented by an X86EMUL_MODE value. */
-- 
1.5.4.rc2

