Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbXCKNyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbXCKNyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbXCKNxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:53:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:43434 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbXCKNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 07/15] KVM: Renumber ioctls
Date: Sun, 11 Mar 2007 15:53:19 +0200
Message-Id: <11736212071708-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes have left the ioctl numbers in complete disarray.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d89189a..93472da 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -229,34 +229,34 @@ struct kvm_cpuid {
 /*
  * ioctls for /dev/kvm fds:
  */
-#define KVM_GET_API_VERSION       _IO(KVMIO, 1)
-#define KVM_CREATE_VM             _IO(KVMIO, 2) /* returns a VM fd */
-#define KVM_GET_MSR_INDEX_LIST    _IOWR(KVMIO, 15, struct kvm_msr_list)
+#define KVM_GET_API_VERSION       _IO(KVMIO,   0x00)
+#define KVM_CREATE_VM             _IO(KVMIO,   0x01) /* returns a VM fd */
+#define KVM_GET_MSR_INDEX_LIST    _IOWR(KVMIO, 0x02, struct kvm_msr_list)
 
 /*
  * ioctls for VM fds
  */
-#define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 10, struct kvm_memory_region)
+#define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 0x40, struct kvm_memory_region)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
  */
-#define KVM_CREATE_VCPU           _IO(KVMIO, 11)
-#define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
+#define KVM_CREATE_VCPU           _IO(KVMIO,  0x41)
+#define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 0x42, struct kvm_dirty_log)
 
 /*
  * ioctls for vcpu fds
  */
-#define KVM_RUN                   _IO(KVMIO, 16)
-#define KVM_GET_REGS              _IOR(KVMIO, 3, struct kvm_regs)
-#define KVM_SET_REGS              _IOW(KVMIO, 4, struct kvm_regs)
-#define KVM_GET_SREGS             _IOR(KVMIO, 5, struct kvm_sregs)
-#define KVM_SET_SREGS             _IOW(KVMIO, 6, struct kvm_sregs)
-#define KVM_TRANSLATE             _IOWR(KVMIO, 7, struct kvm_translation)
-#define KVM_INTERRUPT             _IOW(KVMIO, 8, struct kvm_interrupt)
-#define KVM_DEBUG_GUEST           _IOW(KVMIO, 9, struct kvm_debug_guest)
-#define KVM_GET_MSRS              _IOWR(KVMIO, 13, struct kvm_msrs)
-#define KVM_SET_MSRS              _IOW(KVMIO, 14, struct kvm_msrs)
-#define KVM_SET_CPUID             _IOW(KVMIO, 17, struct kvm_cpuid)
+#define KVM_RUN                   _IO(KVMIO,   0x80)
+#define KVM_GET_REGS              _IOR(KVMIO,  0x81, struct kvm_regs)
+#define KVM_SET_REGS              _IOW(KVMIO,  0x82, struct kvm_regs)
+#define KVM_GET_SREGS             _IOR(KVMIO,  0x83, struct kvm_sregs)
+#define KVM_SET_SREGS             _IOW(KVMIO,  0x84, struct kvm_sregs)
+#define KVM_TRANSLATE             _IOWR(KVMIO, 0x85, struct kvm_translation)
+#define KVM_INTERRUPT             _IOW(KVMIO,  0x86, struct kvm_interrupt)
+#define KVM_DEBUG_GUEST           _IOW(KVMIO,  0x87, struct kvm_debug_guest)
+#define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
+#define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
+#define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
 
 #endif
-- 
1.5.0.2

