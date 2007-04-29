Return-Path: <linux-kernel-owner+w=401wt.eu-S1030780AbXD2ReY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbXD2ReY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXD2Rbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:40 -0400
Received: from gw.goop.org ([64.81.55.164]:58988 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbXD2RaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:08 -0400
Message-Id: <20070429172912.297678000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 09/32] xen: xen configuration
Content-Disposition: inline; filename=xen-config.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Put config options for Xen after the core pieces are in place.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/Kconfig     |    2 ++
 arch/i386/xen/Kconfig |   12 ++++++++++++
 2 files changed, 14 insertions(+)

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
@@ -0,0 +1,12 @@
+#
+# This Kconfig describes xen options
+#
+
+config XEN
+	bool "Enable support for Xen hypervisor"
+	depends on PARAVIRT && !PREEMPT && !SMP
+	default y
+	help
+	  This is the Linux Xen port.  Enabling this will allow the
+	  kernel to boot in a paravirtualized environment under the
+	  Xen hypervisor.

-- 

