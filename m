Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbXDZJYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbXDZJYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXDZJW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:53004 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933773AbXDZJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 01/18] KVM: Use kernel-standard types
Date: Thu, 26 Apr 2007 12:22:01 +0300
Message-Id: <11775793382342-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noted by Joerg Roedel.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index b7e1410..c9b700d 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -63,9 +63,9 @@ struct kvm_ldttss_desc {
 struct svm_cpu_data {
 	int cpu;
 
-	uint64_t asid_generation;
-	uint32_t max_asid;
-	uint32_t next_asid;
+	u64 asid_generation;
+	u32 max_asid;
+	u32 next_asid;
 	struct kvm_ldttss_desc *tss_desc;
 
 	struct page *save_area;
-- 
1.5.0.6

