Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZETLTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZETLTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZETLSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:18:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55257 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZETLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:46 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 03/46] KVM: MMU: Fix comment in page_fault()
Date: Wed, 20 May 2009 14:18:00 +0300
Message-Id: <1242818323-10413-4-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

The original one is for the code before refactoring.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 855eb71..eae9499 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -379,7 +379,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		return r;
 
 	/*
-	 * Look up the shadow pte for the faulting address.
+	 * Look up the guest pte for the faulting address.
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault,
 			     fetch_fault);
-- 
1.6.0.6

