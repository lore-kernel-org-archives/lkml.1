Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbZEXQAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbZEXQAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbZEXPyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 17/45] KVM: Drop request_nmi from stats
Date: Sun, 24 May 2009 18:50:02 +0300
Message-Id: <1243180230-2480-18-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

The stats entry request_nmi is no longer used as the related user space
interface was dropped. So clean it up.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/x86.c              |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 253d8f6..ab7de4a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -441,7 +441,6 @@ struct kvm_vcpu_stat {
 	u32 halt_exits;
 	u32 halt_wakeup;
 	u32 request_irq_exits;
-	u32 request_nmi_exits;
 	u32 irq_exits;
 	u32 host_state_reload;
 	u32 efer_reload;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d7082c..308d8e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -91,7 +91,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
 	{ "hypercalls", VCPU_STAT(hypercalls) },
 	{ "request_irq", VCPU_STAT(request_irq_exits) },
-	{ "request_nmi", VCPU_STAT(request_nmi_exits) },
 	{ "irq_exits", VCPU_STAT(irq_exits) },
 	{ "host_state_reload", VCPU_STAT(host_state_reload) },
 	{ "efer_reload", VCPU_STAT(efer_reload) },
-- 
1.6.0.6

