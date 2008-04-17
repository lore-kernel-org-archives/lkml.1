Return-Path: <linux-kernel-owner+w=401wt.eu-S1765575AbYDQJUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765575AbYDQJUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbYDQJLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:23 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59057
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762777AbYDQJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:03 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/45] KVM: function declaration parameter name cleanup
Date: Thu, 17 Apr 2008 12:10:26 +0300
Message-Id: <1208423450-29415-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The kvm_host.h file for x86 declares the functions kvm_set_cr[0348]. In the
header file their second parameter is named cr0 in all cases. This patch
renames the parameters so that they match the function name.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm_host.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index e6d8df6..46a2996 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -494,9 +494,9 @@ int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason);
 
 void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-void kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr0);
-void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
-void kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
+void kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
+void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+void kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
-- 
1.5.5

