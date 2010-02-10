Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0BJRaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:30:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/40] KVM: Add include guards for coalesced_mmio.h
Date: Wed, 10 Feb 2010 19:22:46 +0200
Message-Id: <1265822589-11155-18-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/coalesced_mmio.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index 4b49f27..e703346 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -1,3 +1,6 @@
+#ifndef __KVM_COALESCED_MMIO_H__
+#define __KVM_COALESCED_MMIO_H__
+
 /*
  * KVM coalesced MMIO
  *
@@ -22,3 +25,5 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
                                        struct kvm_coalesced_mmio_zone *zone);
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
                                          struct kvm_coalesced_mmio_zone *zone);
+
+#endif
-- 
1.6.5.3

