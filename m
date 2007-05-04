Return-Path: <linux-kernel-owner+w=401wt.eu-S1423001AbXEDXuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423001AbXEDXuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422989AbXEDXoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:44:04 -0400
Received: from 116.sub-75-210-58.myvzw.com ([75.210.58.116]:46312 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423067AbXEDXnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:43:35 -0400
Message-Id: <20070504232119.981829318@goop.org>
References: <20070504232051.411946839@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 May 2007 16:21:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 09/29] xen: xen configuration
Content-Disposition: inline; filename=xen-config.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Put config options for Xen after the core pieces are in place.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/i386/Kconfig     |    2 ++
 arch/i386/xen/Kconfig |   11 +++++++++++
 2 files changed, 13 insertions(+)

===================================================================
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -217,6 +217,8 @@ config PARAVIRT
 	  under a hypervisor, improving performance significantly.
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
+
+source "arch/i386/xen/Kconfig"
 
 config VMI
 	bool "VMI Paravirt-ops support"
===================================================================
--- /dev/null
+++ b/arch/i386/xen/Kconfig
@@ -0,0 +1,11 @@
+#
+# This Kconfig describes xen options
+#
+
+config XEN
+	bool "Enable support for Xen hypervisor"
+	depends on PARAVIRT && !PREEMPT && !SMP
+	help
+	  This is the Linux Xen port.  Enabling this will allow the
+	  kernel to boot in a paravirtualized environment under the
+	  Xen hypervisor.

-- 

