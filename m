Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZERJaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZERJaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZERJXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38412 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 17/43] KVM: ia64: fix compilation error in kvm_get_lowest_prio_vcpu
Date: Mon, 18 May 2009 12:22:39 +0300
Message-Id: <1242638585-18470-18-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Zhang <yang.zhang@intel.com>

Modify the arg of kvm_get_lowest_prio_vcpu().
Make it consistent with its declaration.

Signed-off-by: Yang Zhang <yang.zhang@intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d20a5db..774f0d7 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1837,7 +1837,7 @@ int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
 }
 
 struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-				       unsigned long bitmap)
+				       unsigned long *bitmap)
 {
 	struct kvm_vcpu *lvcpu = kvm->vcpus[0];
 	int i;
-- 
1.6.0.6

