Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXLZLQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXLZLQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXLZLGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:49 -0500
Received: from il.qumranet.com ([82.166.9.18]:50470 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXLZLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 40/55] KVM: VMX: Comment VMX primary/secondary exec ctl definitions
Date: Wed, 26 Dec 2007 13:05:45 +0200
Message-Id: <1198667160-22953-41-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Add comments for secondary/primary Processor-Based VM-execution controls.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index d757b36..6d32bc6 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -25,6 +25,9 @@
  *
  */
 
+/*
+ * Definitions of Primary Processor-Based VM-Execution Controls.
+ */
 #define CPU_BASED_VIRTUAL_INTR_PENDING          0x00000004
 #define CPU_BASED_USE_TSC_OFFSETING             0x00000008
 #define CPU_BASED_HLT_EXITING                   0x00000080
@@ -42,6 +45,11 @@
 #define CPU_BASED_MONITOR_EXITING               0x20000000
 #define CPU_BASED_PAUSE_EXITING                 0x40000000
 #define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   0x80000000
+/*
+ * Definitions of Secondary Processor-Based VM-Execution Controls.
+ */
+#define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES 0x00000001
+
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
 #define PIN_BASED_NMI_EXITING                   0x00000008
@@ -54,8 +62,6 @@
 #define VM_ENTRY_SMM                            0x00000400
 #define VM_ENTRY_DEACT_DUAL_MONITOR             0x00000800
 
-#define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES 0x00000001
-
 /* VMCS Encodings */
 enum vmcs_field {
 	GUEST_ES_SELECTOR               = 0x00000800,
-- 
1.5.3.7

