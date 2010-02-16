Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0BPKgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:36:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/38] KVM: VMX: Wire up .fpu_activate() callback
Date: Tue, 16 Feb 2010 12:35:31 +0200
Message-Id: <1266316536-28936-34-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f083b64..82fb810 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4137,6 +4137,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.cache_reg = vmx_cache_reg,
 	.get_rflags = vmx_get_rflags,
 	.set_rflags = vmx_set_rflags,
+	.fpu_activate = vmx_fpu_activate,
 	.fpu_deactivate = vmx_fpu_deactivate,
 
 	.tlb_flush = vmx_flush_tlb,
-- 
1.6.5.3

