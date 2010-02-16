Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0BPKmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:42:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932793Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/38] KVM: Drop kvm_{load,put}_guest_fpu() exports
Date: Tue, 16 Feb 2010 12:35:12 +0200
Message-Id: <1266316536-28936-15-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not used anymore.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cf4eac..c61ec9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5293,7 +5293,6 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	kvm_fx_save(&vcpu->arch.host_fx_image);
 	kvm_fx_restore(&vcpu->arch.guest_fx_image);
 }
-EXPORT_SYMBOL_GPL(kvm_load_guest_fpu);
 
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
@@ -5306,7 +5305,6 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	++vcpu->stat.fpu_reload;
 	set_bit(KVM_REQ_DEACTIVATE_FPU, &vcpu->requests);
 }
-EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
-- 
1.6.5.3

