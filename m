Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYDBSih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYDBSih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbYDBSfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:41 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38409 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757106AbYDBSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:38 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 24] xen: add missing __HYPERVISOR_arch_[0-7] definisions
	which ia64 needs
X-Mercurial-Node: 3b6d3c03baac8d27a77c806903e19c3547dc84f1
Message-Id: <3b6d3c03baac8d27a77c.1207158830@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

Add xen hypercall numbers defined for arch specific use.
ia64/xen domU uses __HYPERVISOR_arch_1 to manipulate paravirtualized
IOSAPIC. Although all those constants aren't used yet by IA64 at this
moment, add all arch specific hypercall numbers.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/xen/interface/xen.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -57,6 +57,16 @@
 #define __HYPERVISOR_event_channel_op     32
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
+
+/* Architecture-specific hypercall definitions. */
+#define __HYPERVISOR_arch_0               48
+#define __HYPERVISOR_arch_1               49
+#define __HYPERVISOR_arch_2               50
+#define __HYPERVISOR_arch_3               51
+#define __HYPERVISOR_arch_4               52
+#define __HYPERVISOR_arch_5               53
+#define __HYPERVISOR_arch_6               54
+#define __HYPERVISOR_arch_7               55
 
 /*
  * VIRTUAL INTERRUPTS


