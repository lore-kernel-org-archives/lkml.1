Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZB0K3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZB0K3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbZB0K10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/37] KVM: ppc: No need to include core-header for KVM in asm-offsets.c currently
Date: Fri, 27 Feb 2009 12:26:29 +0200
Message-Id: <1235730420-7929-7-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kernel/asm-offsets.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 19ee491..42fe4da 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -49,7 +49,7 @@
 #include <asm/iseries/alpaca.h>
 #endif
 #ifdef CONFIG_KVM
-#include <asm/kvm_44x.h>
+#include <linux/kvm_host.h>
 #endif
 
 #if defined(CONFIG_BOOKE) || defined(CONFIG_40x)
@@ -361,8 +361,6 @@ int main(void)
 	DEFINE(PTE_SIZE, sizeof(pte_t));
 
 #ifdef CONFIG_KVM
-	DEFINE(TLBE_BYTES, sizeof(struct kvmppc_44x_tlbe));
-
 	DEFINE(VCPU_HOST_STACK, offsetof(struct kvm_vcpu, arch.host_stack));
 	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
 	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
-- 
1.6.0.6

