Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZGHWcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZGHWcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbZGHWbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47046 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbZGHWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:41 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [2/8] x86: mce: Update X86_MCE description in x86/Kconfig
Message-Id: <20090708223138.E5EF41D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Clarify that this config controls thermal throttling
reporting too
- Clarify the types of errors reported by machine checks
- Drop references to ancient CPUs.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -777,20 +777,12 @@ config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 	  increased on these systems.
 
 config X86_MCE
-	bool "Machine Check Exception"
+	bool "Machine Check / overheating reporting"
 	---help---
-	  Machine Check Exception support allows the processor to notify the
-	  kernel if it detects a problem (e.g. overheating, component failure).
+	  Machine Check support allows the processor to notify the
+	  kernel if it detects a problem (e.g. overheating, data corruption).
 	  The action the kernel takes depends on the severity of the problem,
-	  ranging from a warning message on the console, to halting the machine.
-	  Your processor must be a Pentium or newer to support this - check the
-	  flags in /proc/cpuinfo for mce.  Note that some older Pentium systems
-	  have a design flaw which leads to false MCE events - hence MCE is
-	  disabled on all P5 processors, unless explicitly enabled with "mce"
-	  as a boot argument.  Similarly, if MCE is built in and creates a
-	  problem on some new non-standard machine, you can boot with "nomce"
-	  to disable it.  MCE support simply ignores non-MCE processors like
-	  the 386 and 486, so nearly everyone can say Y here.
+	  ranging from warning messages to halting the machine.
 
 config X86_OLD_MCE
 	depends on X86_32 && X86_MCE
