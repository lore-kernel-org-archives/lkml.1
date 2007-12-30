Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXL3HRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXL3HRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXL3HLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:59483 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbXL3HKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 23/52] KVM: Correct consistent typo: "destory" -> "destroy"
Date: Sun, 30 Dec 2007 09:10:09 +0200
Message-Id: <1198998638-22713-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/x86.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ba78a45..ccba958 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -461,7 +461,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
-void kvm_arch_vcpu_destory(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_arch_hardware_enable(void *garbage);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d6c5191..9c94491 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -824,7 +824,7 @@ unlink:
 	kvm->vcpus[n] = NULL;
 	mutex_unlock(&kvm->lock);
 vcpu_destroy:
-	kvm_arch_vcpu_destory(vcpu);
+	kvm_arch_vcpu_destroy(vcpu);
 	return r;
 }
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 2257a0a..5a1b72f 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -2513,7 +2513,7 @@ fail:
 	return ERR_PTR(r);
 }
 
-void kvm_arch_vcpu_destory(struct kvm_vcpu *vcpu)
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
 	kvm_mmu_unload(vcpu);
-- 
1.5.3.7

