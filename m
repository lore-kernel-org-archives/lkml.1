Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYC1Lkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYC1Lkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYC1LkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:40:20 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44521 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbYC1LkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:40:19 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com,
       yamahata@valinux.co.jp
Subject: [PATCH 01/12] xen: add missing __HYPERVISOR_arch_[0-7] definisions which ia64 needs.
Date: Fri, 28 Mar 2008 20:40:07 +0900
Message-Id: <12067044184147-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12067044183207-git-send-email-yamahata@valinux.co.jp>
References: <12067044183207-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add xen hypercall numbers defined for arch specific use.
ia64/xen domU uses __HYPERVISOR_arch_1 to manipulate paravirtualized
IOSAPIC. Although all those constants aren't used yet by IA64 at this
moment, add all arch specific hypercall numbers.

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

