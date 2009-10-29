Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZJ2LoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZJ2LoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 07:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZJ2LoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 07:44:17 -0400
Received: from borg.medozas.de ([188.40.89.202]:52782 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZJ2LoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 07:44:16 -0400
Date: Thu, 29 Oct 2009 12:44:20 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] x86: mce: restore MCE menuconfig indent
Message-ID: <alpine.LSU.2.00.0910291243090.20695@obet.zrqbmnf.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please take up this patch. It is also pullable
from the 'x86' branch at
  git://dev.medozas.de/linux  x86


parent 964fe080d94db82a3268443e9b9ece4c60246414 (v2.6.32-rc5-81-g964fe08)
commit 9a8802b9129ea4528e345564664551276a480933
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jun 12 17:45:18 2009 +0200

x86: mce: restore MCE menuconfig indent

Commit v2.6.29-rc6-16-gb276268 "unthreaded/unindented" the MCE
options in menuconfig, this patch restores this.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 arch/x86/Kconfig |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 07e0114..a84ed5e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -819,10 +819,12 @@ config X86_MCE
 	  The action the kernel takes depends on the severity of the problem,
 	  ranging from warning messages to halting the machine.
 
+if X86_MCE
+
 config X86_MCE_INTEL
 	def_bool y
 	prompt "Intel MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_LOCAL_APIC
 	---help---
 	   Additional support for intel specific MCE features such as
 	   the thermal monitor.
@@ -830,14 +832,14 @@ config X86_MCE_INTEL
 config X86_MCE_AMD
 	def_bool y
 	prompt "AMD MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_LOCAL_APIC
 	---help---
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
 
 config X86_ANCIENT_MCE
 	def_bool n
-	depends on X86_32 && X86_MCE
+	depends on X86_32
 	prompt "Support for old Pentium 5 / WinChip machine checks"
 	---help---
 	  Include support for machine check handling on old Pentium 5 or WinChip
@@ -850,7 +852,6 @@ config X86_MCE_THRESHOLD
 	default y
 
 config X86_MCE_INJECT
-	depends on X86_MCE
 	tristate "Machine check injector support"
 	---help---
 	  Provide support for injecting machine checks for testing purposes.
@@ -861,6 +862,8 @@ config X86_THERMAL_VECTOR
 	def_bool y
 	depends on X86_MCE_INTEL
 
+endif # X86_MCE
+
 config VM86
 	bool "Enable VM86 support" if EMBEDDED
 	default y
-- 
# Created with git-export-patch

