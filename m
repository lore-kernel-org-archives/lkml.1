Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbXFQKCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbXFQKCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759793AbXFQJpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:51 -0400
Received: from il.qumranet.com ([82.166.9.18]:55154 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051AbXFQJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 31/58] KVM: Use symbolic constants instead of magic numbers
Date: Sun, 17 Jun 2007 12:44:12 +0300
Message-Id: <11820734802043-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 6dd0da9..183d4ca 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -213,7 +213,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
-	FNAME(set_pte)(vcpu, gpte, spte, 6,
+	FNAME(set_pte)(vcpu, gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK,
 		       (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT);
 }
 
-- 
1.5.0.6

