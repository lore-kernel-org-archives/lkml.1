Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbZERJnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbZERJnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZERJZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 36/43] KVM: VMX: Rename kvm_handle_exit() to vmx_handle_exit()
Date: Mon, 18 May 2009 12:22:58 +0300
Message-Id: <1242638585-18470-37-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a static vmx-specific function.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 469787c..85f4fd5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3162,7 +3162,7 @@ static const int kvm_vmx_max_exit_handlers =
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
+static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	u32 exit_reason = vmcs_read32(VM_EXIT_REASON);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3681,7 +3681,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.tlb_flush = vmx_flush_tlb,
 
 	.run = vmx_vcpu_run,
-	.handle_exit = kvm_handle_exit,
+	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.patch_hypercall = vmx_patch_hypercall,
 	.get_irq = vmx_get_irq,
-- 
1.6.0.6

