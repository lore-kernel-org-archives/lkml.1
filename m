Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZHPJew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZHPJew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZHPJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45373 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZHPJaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 40/48] KVM: Reorder ioctls in kvm.h
Date: Sun, 16 Aug 2009 12:30:00 +0300
Message-Id: <1250415008-17175-41-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow the VM ioctls got unsorted; resort.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 632a856..f1dada0 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -495,11 +495,6 @@ struct kvm_irqfd {
  * ioctls for VM fds
  */
 #define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 0x40, struct kvm_memory_region)
-#define KVM_SET_NR_MMU_PAGES      _IO(KVMIO, 0x44)
-#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO, 0x45)
-#define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46,\
-					struct kvm_userspace_memory_region)
-#define KVM_SET_TSS_ADDR          _IO(KVMIO, 0x47)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
@@ -507,6 +502,11 @@ struct kvm_irqfd {
 #define KVM_CREATE_VCPU           _IO(KVMIO,  0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 0x42, struct kvm_dirty_log)
 #define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO, 0x43, struct kvm_memory_alias)
+#define KVM_SET_NR_MMU_PAGES      _IO(KVMIO, 0x44)
+#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO, 0x45)
+#define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46,\
+					struct kvm_userspace_memory_region)
+#define KVM_SET_TSS_ADDR          _IO(KVMIO, 0x47)
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP	  _IO(KVMIO,  0x60)
 #define KVM_IRQ_LINE		  _IOW(KVMIO, 0x61, struct kvm_irq_level)
-- 
1.6.3.3

