Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYBVFIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYBVFIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYBVFHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:07:52 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35775 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750800AbYBVFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:07:50 -0500
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, yamahata@valinux.co.jp
Subject: [PATCH 01/11] xen: add missing __HYPERVISOR_arch_[0-7] definisions which ia64 needs.
Date: Fri, 22 Feb 2008 14:07:38 +0900
Message-Id: <12036568682767-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12036568683779-git-send-email-yamahata@valinux.co.jp>
References: <12036568683779-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 include/xen/interface/xen.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 518a5bf..87ad143 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -58,6 +58,16 @@
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
 
+/* Architecture-specific hypercall definitions. */
+#define __HYPERVISOR_arch_0               48
+#define __HYPERVISOR_arch_1               49
+#define __HYPERVISOR_arch_2               50
+#define __HYPERVISOR_arch_3               51
+#define __HYPERVISOR_arch_4               52
+#define __HYPERVISOR_arch_5               53
+#define __HYPERVISOR_arch_6               54
+#define __HYPERVISOR_arch_7               55
+
 /*
  * VIRTUAL INTERRUPTS
  *
-- 
1.5.3

