Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYFZMgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYFZMgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYFZM3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:13 -0400
Received: from il.qumranet.com ([212.179.150.194]:32398 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbYFZM2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 50/50] KVM: MMU: Fix printk format
Date: Thu, 26 Jun 2008 15:28:32 +0300
Message-Id: <1214483312-9265-51-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5994645..1fd8e3b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1116,7 +1116,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		mark_page_dirty(vcpu->kvm, gfn);
 
 	pgprintk("%s: setting spte %llx\n", __func__, spte);
-	pgprintk("instantiating %s PTE (%s) at %d (%llx) addr %llx\n",
+	pgprintk("instantiating %s PTE (%s) at %ld (%llx) addr %p\n",
 		 (spte&PT_PAGE_SIZE_MASK)? "2MB" : "4kB",
 		 (spte&PT_WRITABLE_MASK)?"RW":"R", gfn, spte, shadow_pte);
 	set_shadow_pte(shadow_pte, spte);
-- 
1.5.6

