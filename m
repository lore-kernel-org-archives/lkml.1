Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbYAFOqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbYAFOqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbYAFOkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:46649 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 20/33] KVM: Expose ioapic to ia64 save/restore APIs
Date: Sun,  6 Jan 2008 16:39:26 +0200
Message-Id: <1199630379-28638-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

IA64 also needs to see ioapic structure in irqchip.

Signed-off-by: xiantao.zhang@intel.com <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f0bebd6..de9f28d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -53,6 +53,8 @@ struct kvm_irqchip {
 		char dummy[512];  /* reserving space */
 #ifdef CONFIG_X86
 		struct kvm_pic_state pic;
+#endif
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
 		struct kvm_ioapic_state ioapic;
 #endif
 	} chip;
-- 
1.5.3.7

