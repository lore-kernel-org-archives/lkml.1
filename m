Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXKGOWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXKGOWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbXKGOUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:45 -0500
Received: from il.qumranet.com ([82.166.9.18]:50643 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777AbXKGOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:42 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 6/8] KVM: PVDMA Guest: Add Makefile rule
Date: Wed,  7 Nov 2007 16:21:07 +0200
Message-Id: <11944452693466-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1194445269469-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <11944452691714-git-send-email-amit.shah@qumranet.com>
 <11944452692774-git-send-email-amit.shah@qumranet.com>
 <11944452694052-git-send-email-amit.shah@qumranet.com>
 <1194445269859-git-send-email-amit.shah@qumranet.com>
 <1194445269469-git-send-email-amit.shah@qumranet.com>
Message-Id: <6bbd61409e4779febab1eaf03796455b22e8ea70.1194445109.git.amit.shah@qumranet.com>
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add Makefile rule for compiling the new file
that we create

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 drivers/kvm/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/Makefile b/drivers/kvm/Makefile
index cf18ad4..f492e3e 100644
--- a/drivers/kvm/Makefile
+++ b/drivers/kvm/Makefile
@@ -8,3 +8,5 @@ kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
 kvm-amd-objs = svm.o
 obj-$(CONFIG_KVM_AMD) += kvm-amd.o
+kvm-pv-dma-objs = kvm_pv_dma.o
+obj-$(CONFIG_KVM_PV_DMA) += kvm_pv_dma.o
-- 
1.5.3

