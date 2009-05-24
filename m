Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbZEXP67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbZEXP67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZEXPud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:50:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41819 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZEXPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:31 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 02/45] KVM: Remove kvm_push_irq()
Date: Sun, 24 May 2009 18:49:47 +0300
Message-Id: <1243180230-2480-3-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

No longer used.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2ab6791..39350b2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -30,11 +30,4 @@ static inline u8 kvm_pop_irq(struct kvm_vcpu *vcpu)
 		clear_bit(word_index, &vcpu->arch.irq_summary);
 	return irq;
 }
-
-static inline void kvm_push_irq(struct kvm_vcpu *vcpu, u8 irq)
-{
-        set_bit(irq, vcpu->arch.irq_pending);
-        set_bit(irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
-}
-
 #endif
-- 
1.6.0.6

