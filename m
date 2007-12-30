Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbXL3HRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbXL3HRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXL3HLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:59494 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbXL3HKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 22/52] KVM: Remove unused "rmap_overflow" variable
Date: Sun, 30 Dec 2007 09:10:08 +0200
Message-Id: <1198998638-22713-23-git-send-email-avi@qumranet.com>
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
 drivers/kvm/kvm.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1901456..ba78a45 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -318,7 +318,6 @@ struct kvm {
 	unsigned int n_alloc_mmu_pages;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
-	unsigned long rmap_overflow;
 	struct list_head vm_list;
 	struct file *filp;
 	struct kvm_io_bus mmio_bus;
-- 
1.5.3.7

