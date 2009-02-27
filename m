Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZB0K1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZB0K1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZB0K1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbZB0K1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/37] KVM: ppc: remove last 44x-specific bits from booke.c
Date: Fri, 27 Feb 2009 12:26:25 +0200
Message-Id: <1235730420-7929-3-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/booke.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 1e692ac..a73b395 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -30,10 +30,8 @@
 #include <asm/kvm_ppc.h>
 #include "timing.h"
 #include <asm/cacheflush.h>
-#include <asm/kvm_44x.h>
 
 #include "booke.h"
-#include "44x_tlb.h"
 
 unsigned long kvmppc_booke_handlers;
 
@@ -284,7 +282,6 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		r = RESUME_GUEST;
 		break;
 
-	/* XXX move to a 440-specific file. */
 	case BOOKE_INTERRUPT_DTLB_MISS: {
 		unsigned long eaddr = vcpu->arch.fault_dear;
 		int gtlb_index;
@@ -327,7 +324,6 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		break;
 	}
 
-	/* XXX move to a 440-specific file. */
 	case BOOKE_INTERRUPT_ITLB_MISS: {
 		unsigned long eaddr = vcpu->arch.pc;
 		gpa_t gpaddr;
-- 
1.6.0.6

