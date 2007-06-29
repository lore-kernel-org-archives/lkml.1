Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXF2TtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXF2TtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXF2TtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:49:14 -0400
Received: from gw.goop.org ([64.81.55.164]:37105 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbXF2TtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:49:13 -0400
Message-ID: <468561FF.4030604@goop.org>
Date: Fri, 29 Jun 2007 15:48:15 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH] xen: fix x86 config dependencies
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we set dependencies on CPU features.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian Bunk <bunk@stusta.de>
---
 arch/i386/xen/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/Kconfig
+++ b/arch/i386/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT
+	depends on PARAVIRT && X86_CMPXCHG && X86_TSC
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the


