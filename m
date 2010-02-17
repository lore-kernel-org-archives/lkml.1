Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645Ab0BQNpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:45:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab0BQNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:33 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/20] KVM: Fix Codestyle in virt/kvm/coalesced_mmio.c
Date: Wed, 17 Feb 2010 15:45:11 +0200
Message-Id: <1266414330-27444-2-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jochen Maes <jochen.maes@sejo.be>

Fixed 2 codestyle issues in virt/kvm/coalesced_mmio.c

Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/coalesced_mmio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5de6594..5169736 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -133,7 +133,7 @@ void kvm_coalesced_mmio_free(struct kvm *kvm)
 }
 
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
-				         struct kvm_coalesced_mmio_zone *zone)
+					 struct kvm_coalesced_mmio_zone *zone)
 {
 	struct kvm_coalesced_mmio_dev *dev = kvm->coalesced_mmio_dev;
 
@@ -166,7 +166,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	i = dev->nb_zones;
-	while(i) {
+	while (i) {
 		z = &dev->zone[i - 1];
 
 		/* unregister all zones
-- 
1.6.5.3

