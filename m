Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0BPKjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:39:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/38] KVM: ia64: Fix string literal continuation lines
Date: Tue, 16 Feb 2010 12:35:32 +0200
Message-Id: <1266316536-28936-35-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/mmio.c |    4 ++--
 arch/ia64/kvm/vcpu.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kvm/mmio.c b/arch/ia64/kvm/mmio.c
index 9bf55af..fb8f9f5 100644
--- a/arch/ia64/kvm/mmio.c
+++ b/arch/ia64/kvm/mmio.c
@@ -316,8 +316,8 @@ void emulate_io_inst(struct kvm_vcpu *vcpu, u64 padr, u64 ma)
 		return;
 	} else {
 		inst_type = -1;
-		panic_vm(vcpu, "Unsupported MMIO access instruction! \
-				Bunld[0]=0x%lx, Bundle[1]=0x%lx\n",
+		panic_vm(vcpu, "Unsupported MMIO access instruction! "
+				"Bunld[0]=0x%lx, Bundle[1]=0x%lx\n",
 				bundle.i64[0], bundle.i64[1]);
 	}
 
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index dce75b7..958815c 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -1639,8 +1639,8 @@ void vcpu_set_psr(struct kvm_vcpu *vcpu, unsigned long val)
 	 * Otherwise panic
 	 */
 	if (val & (IA64_PSR_PK | IA64_PSR_IS | IA64_PSR_VM))
-		panic_vm(vcpu, "Only support guests with vpsr.pk =0 \
-				& vpsr.is=0\n");
+		panic_vm(vcpu, "Only support guests with vpsr.pk =0 "
+				"& vpsr.is=0\n");
 
 	/*
 	 * For those IA64_PSR bits: id/da/dd/ss/ed/ia
-- 
1.6.5.3

