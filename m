Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZHPJiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZHPJiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZHPJh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:37:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45348 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbZHPJaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/48] KVM: remove redundant declarations
Date: Sun, 16 Aug 2009 12:29:40 +0300
Message-Id: <1250415008-17175-21-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

Changing s390 code in kvm_arch_vcpu_load/put come across this header
declarations. They are complete duplicates, not even useful forward
declarations as nothing using it is in between (maybe it was that in
the past).

This patch removes the two dispensable lines.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7724dcb..19240fe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -249,8 +249,6 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg);
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
-void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 
 int kvm_dev_ioctl_check_extension(long ext);
 
-- 
1.6.3.3

