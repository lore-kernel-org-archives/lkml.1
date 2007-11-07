Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXKGOW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXKGOW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbXKGOUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:48 -0500
Received: from il.qumranet.com ([82.166.9.18]:50647 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857AbXKGOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:42 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 7/8] PVDMA: Guest: Add Kconfig options to select PVDMA
Date: Wed,  7 Nov 2007 16:21:08 +0200
Message-Id: <11944452693579-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11944452693466-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <11944452691714-git-send-email-amit.shah@qumranet.com>
 <11944452692774-git-send-email-amit.shah@qumranet.com>
 <11944452694052-git-send-email-amit.shah@qumranet.com>
 <1194445269859-git-send-email-amit.shah@qumranet.com>
 <1194445269469-git-send-email-amit.shah@qumranet.com>
 <11944452693466-git-send-email-amit.shah@qumranet.com>
Message-Id: <01dd7657bda537d738ea92330606592fa8aaf3c5.1194445109.git.amit.shah@qumranet.com>
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is to be enabled on a guest. Currently, only
'module' works; compiling it in freezes at HD bringup

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 drivers/kvm/Kconfig |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 6569206..3385c10 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -47,6 +47,14 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
+config KVM_PV_DMA
+	tristate "Para-virtualized DMA access"
+       ---help---
+         Provides support for DMA operations in the guest. A hypercall
+	 is raised to the host to enable devices owned by guest to use
+	 DMA. Select this if compiling a guest kernel and you need
+	 paravirtualized DMA operations.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/lguest/Kconfig
-- 
1.5.3

