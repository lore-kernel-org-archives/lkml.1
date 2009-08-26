Return-Path: <linux-kernel-owner+w=401wt.eu-S932554AbZHZKdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbZHZKdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZHZKdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 41/47] KVM: Add __KERNEL__ guards to exported headers
Date: Wed, 26 Aug 2009 13:30:03 +0300
Message-Id: <1251282609-12835-42-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_para.h |    4 ++++
 arch/s390/include/asm/kvm_para.h |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/kvm_para.h
index 0d6d8ca..1588aee 100644
--- a/arch/ia64/include/asm/kvm_para.h
+++ b/arch/ia64/include/asm/kvm_para.h
@@ -19,9 +19,13 @@
  *
  */
 
+#ifdef __KERNEL__
+
 static inline unsigned int kvm_arch_para_features(void)
 {
 	return 0;
 }
 
 #endif
+
+#endif
diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
index 2c50379..6964db2 100644
--- a/arch/s390/include/asm/kvm_para.h
+++ b/arch/s390/include/asm/kvm_para.h
@@ -13,6 +13,8 @@
 #ifndef __S390_KVM_PARA_H
 #define __S390_KVM_PARA_H
 
+#ifdef __KERNEL__
+
 /*
  * Hypercalls for KVM on s390. The calling convention is similar to the
  * s390 ABI, so we use R2-R6 for parameters 1-5. In addition we use R1
@@ -147,4 +149,6 @@ static inline unsigned int kvm_arch_para_features(void)
 	return 0;
 }
 
+#endif
+
 #endif /* __S390_KVM_PARA_H */
-- 
1.6.4.1

