Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbZB0KiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbZB0KiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZB0K2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/37] KVM: Remove duplicated prototype of kvm_arch_destroy_vm
Date: Fri, 27 Feb 2009 12:26:43 +0200
Message-Id: <1235730420-7929-21-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e92212f..3cf0ede 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -237,7 +237,6 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   int user_alloc);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
-void kvm_arch_destroy_vm(struct kvm *kvm);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
-- 
1.6.0.6

