Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0BMICL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:02:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab0BMICB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:01 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/39] KVM: x86: Moving PT_*_LEVEL to mmu.h
Date: Sat, 13 Feb 2010 10:01:22 +0200
Message-Id: <1266048119-14325-3-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

We can use them in x86.c and vmx.c now...

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/mmu.c |    4 ----
 arch/x86/kvm/mmu.h |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 25aabd0..12ccf14 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -143,10 +143,6 @@ module_param(oos_shadow, bool, 0644);
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
 
-#define PT_PDPE_LEVEL 3
-#define PT_DIRECTORY_LEVEL 2
-#define PT_PAGE_TABLE_LEVEL 1
-
 #define RMAP_EXT 4
 
 #define ACC_EXEC_MASK    1
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 4567d80..ff58342 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -38,6 +38,10 @@
 #define PT32_ROOT_LEVEL 2
 #define PT32E_ROOT_LEVEL 3
 
+#define PT_PDPE_LEVEL 3
+#define PT_DIRECTORY_LEVEL 2
+#define PT_PAGE_TABLE_LEVEL 1
+
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
-- 
1.6.5.3

