Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZF1Q20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZF1Q20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZF1Q1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1069 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbZF1Q1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Avi Kivity <avi@redhat.com>,
       Xiantao Zhang <xiantao.zhang@intel.com>, linux-ia64@vger.kernel.org,
       kvm@vger.kernel.org, kvm-ia64@vger.kernel.org
Subject: [PATCH 02/62] arch/ia64: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:07 -0700
Message-Id: <666c19a5e3efb5aff766bb05f4221903017b25bc.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/kernel/esi.c  |    2 +-
 arch/ia64/kvm/process.c |    6 +++---
 arch/ia64/kvm/vcpu.c    |    2 +-
 arch/ia64/kvm/vtlb.c    |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kernel/esi.c b/arch/ia64/kernel/esi.c
index ebf4e98..d5764a3 100644
--- a/arch/ia64/kernel/esi.c
+++ b/arch/ia64/kernel/esi.c
@@ -65,7 +65,7 @@ static int __init esi_init (void)
 	}
 
 	if (!esi)
-		return -ENODEV;;
+		return -ENODEV;
 
 	systab = __va(esi);
 
diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index a8f84da..bb862fb 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -130,7 +130,7 @@ static void collect_interruption(struct kvm_vcpu *vcpu)
 	if (vdcr & IA64_DCR_PP) {
 		vpsr |= IA64_PSR_PP;
 	} else {
-		vpsr &= ~IA64_PSR_PP;;
+		vpsr &= ~IA64_PSR_PP;
 	}
 
 	vcpu_set_psr(vcpu, vpsr);
@@ -594,11 +594,11 @@ static void set_pal_call_data(struct kvm_vcpu *vcpu)
 		p->u.pal_data.gr30 = vcpu_get_gr(vcpu, 30);
 		break;
 	case PAL_BRAND_INFO:
-		p->u.pal_data.gr29 = gr29;;
+		p->u.pal_data.gr29 = gr29;
 		p->u.pal_data.gr30 = kvm_trans_pal_call_args(vcpu, gr30);
 		break;
 	default:
-		p->u.pal_data.gr29 = gr29;;
+		p->u.pal_data.gr29 = gr29;
 		p->u.pal_data.gr30 = vcpu_get_gr(vcpu, 30);
 	}
 	p->u.pal_data.gr28 = gr28;
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index a2c6c15..46b02cb 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -406,7 +406,7 @@ void getreg(unsigned long regnum, unsigned long *val,
 	 * Now look at registers in [0-31] range and init correct UNAT
 	 */
 	addr = (unsigned long)regs;
-	unat = &regs->eml_unat;;
+	unat = &regs->eml_unat;
 
 	addr += gr_info[regnum];
 
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 4290a42..20b3852 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -135,7 +135,7 @@ struct thash_data *__vtr_lookup(struct kvm_vcpu *vcpu, u64 va, int type)
 	u64 rid;
 
 	rid = vcpu_get_rr(vcpu, va);
-	rid = rid & RR_RID_MASK;;
+	rid = rid & RR_RID_MASK;
 	if (type == D_TLB) {
 		if (vcpu_quick_region_check(vcpu->arch.dtr_regions, va)) {
 			for (trp = (struct thash_data *)&vcpu->arch.dtrs, i = 0;
@@ -518,7 +518,7 @@ struct thash_data *vtlb_lookup(struct kvm_vcpu *v, u64 va, int is_data)
 
 	struct thash_cb *hcb = &v->arch.vtlb;
 
-	cch = __vtr_lookup(v, va, is_data);;
+	cch = __vtr_lookup(v, va, is_data);
 	if (cch)
 		return cch;
 
-- 
1.6.3.1.10.g659a0.dirty

