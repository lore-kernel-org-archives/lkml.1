Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZETLYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZETLYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbZETLTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbZETLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 36/46] KVM: ia64: remove empty function vti_vcpu_load()
Date: Wed, 20 May 2009 14:18:33 +0300
Message-Id: <1242818323-10413-37-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

vti_vcpu_load() doesn't do anything, so lets get rid of it.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by : Xiantao Zhang<xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 9addca6..7263171 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1100,10 +1100,6 @@ static void kvm_free_vmm_area(void)
 	}
 }
 
-static void vti_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-{
-}
-
 static int vti_init_vpd(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -1348,7 +1344,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	vcpu->kvm = kvm;
 
 	cpu = get_cpu();
-	vti_vcpu_load(vcpu, cpu);
 	r = vti_vcpu_setup(vcpu, id);
 	put_cpu();
 
-- 
1.6.0.6

