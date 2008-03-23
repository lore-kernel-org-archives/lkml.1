Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbYCWIWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbYCWIWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbYCWIJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:03 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2268 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbYCWIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:00 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 059/148] include/asm-x86/kvm_host.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:34 -0700
Message-Id: <1206259443-13210-60-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/kvm_host.h |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 4702b04..68ee390 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -22,15 +22,16 @@
 
 #define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
-#define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
+#define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS |	\
+				  0xFFFFFF0000000000ULL)
 
-#define KVM_GUEST_CR0_MASK \
+#define KVM_GUEST_CR0_MASK				   \
 	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE \
 	 | X86_CR0_NW | X86_CR0_CD)
-#define KVM_VM_CR0_ALWAYS_ON \
+#define KVM_VM_CR0_ALWAYS_ON						\
 	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE | X86_CR0_TS \
 	 | X86_CR0_MP)
-#define KVM_GUEST_CR4_MASK \
+#define KVM_GUEST_CR4_MASK						\
 	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
 #define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
@@ -133,12 +134,12 @@ struct kvm_pte_chain {
 union kvm_mmu_page_role {
 	unsigned word;
 	struct {
-		unsigned glevels : 4;
-		unsigned level : 4;
-		unsigned quadrant : 2;
-		unsigned pad_for_nice_hex_output : 6;
-		unsigned metaphysical : 1;
-		unsigned access : 3;
+		unsigned glevels:4;
+		unsigned level:4;
+		unsigned quadrant:2;
+		unsigned pad_for_nice_hex_output:6;
+		unsigned metaphysical:1;
+		unsigned access:3;
 	};
 };
 
@@ -606,6 +607,7 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 #define TSS_BASE_SIZE 0x68
 #define TSS_IOPB_SIZE (65536 / 8)
 #define TSS_REDIRECTION_SIZE (256 / 8)
-#define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
+#define RMODE_TSS_SIZE							\
+	(TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
 #endif
-- 
1.5.4.rc2

