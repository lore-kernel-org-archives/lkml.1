Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYAAPwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYAAPwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYAAPhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:33786 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbYAAPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 50/54] KVM: MMU: Adjust mmu_set_spte() debug code for gpte removal
Date: Tue,  1 Jan 2008 17:36:16 +0200
Message-Id: <1199201780-14001-51-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index a91e05b..b4dd726 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -888,9 +888,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	int was_rmapped = is_rmap_pte(*shadow_pte);
 	struct page *page;
 
-	pgprintk("%s: spte %llx gpte %llx access %x write_fault %d"
+	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
-		 __FUNCTION__, *shadow_pte, (u64)gpte, pt_access,
+		 __FUNCTION__, *shadow_pte, pt_access,
 		 write_fault, user_fault, gfn);
 
 	/*
-- 
1.5.3.7

