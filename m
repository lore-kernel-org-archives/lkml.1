Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYLHLyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYLHLyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYLHLib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 22/45] KVM: Clean up kvm_x86_emulate.h
Date: Mon,  8 Dec 2008 13:36:33 +0200
Message-Id: <1228736216-15787-23-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Remove one left improper comment of removed CR2.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_x86_emulate.h |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index 25179a2..16a0026 100644
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -146,22 +146,18 @@ struct x86_emulate_ctxt {
 	/* Register state before/after emulation. */
 	struct kvm_vcpu *vcpu;
 
-	/* Linear faulting address (if emulating a page-faulting instruction) */
 	unsigned long eflags;
-
 	/* Emulated execution mode, represented by an X86EMUL_MODE value. */
 	int mode;
-
 	u32 cs_base;
 
 	/* decode cache */
-
 	struct decode_cache decode;
 };
 
 /* Repeat String Operation Prefix */
-#define REPE_PREFIX  1
-#define REPNE_PREFIX    2
+#define REPE_PREFIX	1
+#define REPNE_PREFIX	2
 
 /* Execution mode, passed to the emulator. */
 #define X86EMUL_MODE_REAL     0	/* Real mode.             */
@@ -170,7 +166,7 @@ struct x86_emulate_ctxt {
 #define X86EMUL_MODE_PROT64   8	/* 64-bit (long) mode.    */
 
 /* Host execution mode. */
-#if defined(__i386__)
+#if defined(CONFIG_X86_32)
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT32
 #elif defined(CONFIG_X86_64)
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT64
-- 
1.6.0.3

