Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbZHWMCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbZHWMCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933701AbZHWMCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:02:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933540AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/46] KVM: Move kvm_cpu_get_interrupt() declaration to x86 code
Date: Sun, 23 Aug 2009 14:56:24 +0300
Message-Id: <1251028605-31977-26-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

It is implemented only by x86.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 include/linux/kvm_host.h        |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 30b625d..3f4f00a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -797,5 +797,6 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_age_hva(struct kvm *kvm, unsigned long hva);
 int cpuid_maxphyaddr(struct kvm_vcpu *vcpu);
+int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6ec9fc5..2c6a5f0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -341,7 +341,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_free_all_assigned_devices(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
 
-int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
-- 
1.6.4.1

