Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0BHLAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:00:07 -0500
Received: from palm.sejo.be ([86.39.155.213]:44969 "EHLO palm.sejo.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab0BHLAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:00:05 -0500
X-Greylist: delayed 1893 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 06:00:04 EST
From: Jochen Maes <jochen.maes@sejo.be>
To: avi@redhat.com
Cc: linux-kernel@vger.kernel.org, Jochen Maes <jochen.maes@sejo.be>
Subject: [PATCH] virt: kvm: Fix Codestyle
Date: Mon,  8 Feb 2010 11:29:33 +0100
Message-Id: <1265624973-22707-1-git-send-email-jochen.maes@sejo.be>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 2 codestyle issues in virt/kvm/coalesced.c

Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
---
 virt/kvm/coalesced_mmio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 04d69cd..a9cd03e 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -110,7 +110,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 }
 
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
-				         struct kvm_coalesced_mmio_zone *zone)
+					 struct kvm_coalesced_mmio_zone *zone)
 {
 	struct kvm_coalesced_mmio_dev *dev = kvm->coalesced_mmio_dev;
 
@@ -143,7 +143,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 	down_write(&kvm->slots_lock);
 
 	i = dev->nb_zones;
-	while(i) {
+	while (i) {
 		z = &dev->zone[i - 1];
 
 		/* unregister all zones
-- 
1.6.6

