Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYIKCbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYIKCbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 22:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYIKCaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 22:30:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:17863 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYIKCa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,375,1217833200"; 
   d="scan'208";a="335093953"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 2/2] x86: Move FEATURE_CONTROL bits to msr-index.h
Date: Thu, 11 Sep 2008 10:33:52 +0800
Message-Id: <1221100432-9511-3-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For MSR_IA32_FEATURE_CONTROL is already there.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
---
 arch/x86/kvm/vmx.h          |    3 ---
 include/asm-x86/msr-index.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index bb35c23..aef8f3f 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,9 +331,6 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define FEATURE_CONTROL_LOCKED			(1<<0)
-#define FEATURE_CONTROL_VMXON_ENABLED		(1<<2)
-
 #define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	9
 #define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	10
 
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 0bb4330..dabd10f 100644
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
1.5.4.5

