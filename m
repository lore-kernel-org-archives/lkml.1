Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbZB1Br0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbZB1Br0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZB1Bmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41779 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZB1Bl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:58 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/30] KVM: define KVM_CAP_DEVICE_DEASSIGNMENT
Date: Sat, 28 Feb 2009 03:41:42 +0200
Message-Id: <1235785309-12835-24-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weidong Han <weidong.han@intel.com>

define KVM_CAP_DEVICE_DEASSIGNMENT and KVM_DEASSIGN_PCI_DEVICE
for device deassignment.

the ioctl has been already implemented in the
commit: 0a920356748df4fb06e86c21c23d2ed6d31d37ad

Acked-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index dd48225..0d94b27 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -406,6 +406,9 @@ struct kvm_trace_rec {
 #define KVM_CAP_IRQ_ROUTING 25
 #endif
 #define KVM_CAP_IRQ_INJECT_STATUS 26
+#ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
+#define KVM_CAP_DEVICE_DEASSIGNMENT 27
+#endif
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -480,6 +483,8 @@ struct kvm_irq_routing {
 #define KVM_ASSIGN_IRQ _IOR(KVMIO, 0x70, \
 			    struct kvm_assigned_irq)
 #define KVM_REINJECT_CONTROL      _IO(KVMIO, 0x71)
+#define KVM_DEASSIGN_PCI_DEVICE _IOR(KVMIO, 0x72, \
+				     struct kvm_assigned_pci_dev)
 
 /*
  * ioctls for vcpu fds
-- 
1.6.0.6

