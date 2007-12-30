Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXL3HRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXL3HRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXL3HLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:12 -0500
Received: from il.qumranet.com ([82.166.9.18]:59482 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbXL3HKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 21/52] KVM: MMU: Remove unused variable
Date: Sun, 30 Dec 2007 09:10:07 +0200
Message-Id: <1198998638-22713-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index be66401..77a2b22 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -72,7 +72,6 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 			    struct kvm_vcpu *vcpu, gva_t addr,
 			    int write_fault, int user_fault, int fetch_fault)
 {
-	pt_element_t *table;
 	pt_element_t pte;
 	gfn_t table_gfn;
 	unsigned index;
-- 
1.5.3.7

