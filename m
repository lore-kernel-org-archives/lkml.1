Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYKDR1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYKDR1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYKDR1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:27:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50705 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYKDR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:27:22 -0500
Date: Wed, 5 Nov 2008 02:27:19 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] change CONFIG_NUMA description
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CONFIG_NUMA description talk about a bit old thing.
So, following changes are better.

o CONFIG_NUMA is no longer EXPERIMENTAL
o Opteron is not the only processor of NUMA topology on x86_64 no longer, but also Intel Core7i has it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/x86/Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: b/arch/x86/Kconfig
===================================================================
--- a/arch/x86/Kconfig	2008-11-05 01:11:24.000000000 +0900
+++ b/arch/x86/Kconfig	2008-11-05 02:09:38.000000000 +0900
@@ -951,7 +951,7 @@ config ARCH_PHYS_ADDR_T_64BIT
 
 # Common NUMA Features
 config NUMA
-	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
+	bool "Numa Memory Allocation and Scheduler Support"
 	depends on SMP
 	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
 	default n if X86_PC
@@ -964,9 +964,8 @@ config NUMA
 
 	  For 32-bit this is currently highly experimental and should be only
 	  used for kernel development. It might also cause boot failures.
-	  For 64-bit this is recommended on all multiprocessor Opteron systems.
-	  If the system is EM64T, you should say N unless your system is
-	  EM64T NUMA.
+	  For 64-bit this is recommended if the system is Intel Core 7i or later or AMD Opteron.
+	  Otherwise, you should say N unless your system is EM64T NUMA.
 
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)


