Return-Path: <linux-kernel-owner+w=401wt.eu-S966363AbXEKTVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966363AbXEKTVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbXEKTTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:19:38 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:36778 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966149AbXEKTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:19:36 -0400
Message-Id: <20070511001158.810692000@goop.org>
References: <20070511000643.025196000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 17:06:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 08/28]xen: xen configuration
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

