Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZBZOXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZBZOXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZBZOQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43076 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 18/40] KVM: Remove old kvm_guest_debug structs
Date: Thu, 26 Feb 2009 16:15:08 +0200
Message-Id: <1235657730-27683-19-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Remove the remaining arch fragments of the old guest debug interface
that now break non-x86 builds.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h    |    2 --
 arch/powerpc/include/asm/kvm_host.h |    6 ------
 arch/s390/include/asm/kvm_host.h    |    3 ---
 3 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 7da0c09..46f8b0e 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -239,8 +239,6 @@ struct kvm_vm_data {
 
 struct kvm;
 struct kvm_vcpu;
-struct kvm_guest_debug{
-};
 
 struct kvm_mmio_req {
 	uint64_t addr;          /*  physical address		*/
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index c1e436f..a226005 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -200,10 +200,4 @@ struct kvm_vcpu_arch {
 	unsigned long pending_exceptions;
 };
 
-struct kvm_guest_debug {
-	int enabled;
-	unsigned long bp[4];
-	int singlestep;
-};
-
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3c55e41..c6e674f 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -21,9 +21,6 @@
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
 
-struct kvm_guest_debug {
-};
-
 struct sca_entry {
 	atomic_t scn;
 	__u64	reserved;
-- 
1.6.0.6

