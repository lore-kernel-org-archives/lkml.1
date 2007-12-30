Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXL3HSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXL3HSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbXL3HLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:15 -0500
Received: from il.qumranet.com ([82.166.9.18]:59495 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbXL3HKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 24/52] KVM: Move misplaced comment
Date: Sun, 30 Dec 2007 09:10:10 +0200
Message-Id: <1198998638-22713-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ccba958..52e8018 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -135,15 +135,15 @@ struct kvm_mmu {
 
 #define KVM_NR_MEM_OBJS 40
 
+/*
+ * We don't want allocation failures within the mmu code, so we preallocate
+ * enough memory for a single page fault in a cache.
+ */
 struct kvm_mmu_memory_cache {
 	int nobjs;
 	void *objects[KVM_NR_MEM_OBJS];
 };
 
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
 struct kvm_guest_debug {
 	int enabled;
 	unsigned long bp[4];
-- 
1.5.3.7

