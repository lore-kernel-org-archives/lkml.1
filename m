Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186AbZHSNDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbZHSNDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZHSNDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:03:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50590 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752034AbZHSNCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 46/47] KVM: document lock nesting rule
Date: Wed, 19 Aug 2009 16:02:42 +0300
Message-Id: <1250686963-8357-47-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

Document kvm->lock nesting within kvm->slots_lock

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5946065..fc1b58a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -68,7 +68,7 @@ MODULE_LICENSE("GPL");
 /*
  * Ordering of locks:
  *
- * 		kvm->lock --> kvm->irq_lock
+ * 		kvm->slots_lock --> kvm->lock --> kvm->irq_lock
  */
 
 DEFINE_SPINLOCK(kvm_lock);
-- 
1.6.3.3

