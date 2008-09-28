Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYI1Ptf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYI1Ptf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYI1Ppi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbYI1Ppf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 15/25] x86: Move FEATURE_CONTROL bits to msr-index.h
Date: Sun, 28 Sep 2008 18:44:51 +0300
Message-Id: <1222616701-1206-16-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

For MSR_IA32_FEATURE_CONTROL is already there.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.h          |    3 ---
 include/asm-x86/msr-index.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 44cfab7..3e010d2 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,9 +331,6 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define FEATURE_CONTROL_LOCKED		    (1<<0)
-#define FEATURE_CONTROL_VMXON_ENABLED	    (1<<2)
-
 #define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	9
 #define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	10
 
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 63632b8..715f951 100644
--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -178,6 +178,9 @@
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 
+#define FEATURE_CONTROL_LOCKED		(1<<0)
+#define FEATURE_CONTROL_VMXON_ENABLED	(1<<2)
+
 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
 #define MSR_IA32_APICBASE_ENABLE	(1<<11)
-- 
1.6.0.1

