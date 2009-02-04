Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbZBDUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbZBDUoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZBDUoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:44:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:62417 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZBDUoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:44:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition:user-agent;
        b=m6+waKpAgp97decXh/LRESJdCTEBapaVw3QhdC+wbiq8shp9+vYWffaLuJC25CsEhu
         4p/V3VE0xmjpKJe/JsXtXIEMldR7TupAjIkFinkrx6rPsKmxWoUzGkAdcGGSx0VgHtGQ
         dXaT4+AGGpu6msdL304S9oAMmaYO0QCOUwbcM=
Date: Wed, 4 Feb 2009 21:44:04 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: hpa@zytor.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86/Kconfig.cpu: make Kconfig help readable in the console
Message-ID: <20090204204404.GA28323@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, hpa@zytor.com, mingo@elte.hu,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 4 Feb 2009 21:14:50 +0100
Subject: [PATCH] x86/Kconfig.cpu: make Kconfig help readable in the console

Impact: cleanup

Some lines exceed the 80 char width making them unreadable.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/Kconfig.cpu |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8078955..0f294ec 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -167,9 +167,9 @@ config MK7
 config MK8
 	bool "Opteron/Athlon64/Hammer/K8"
 	help
-	  Select this for an AMD Opteron or Athlon64 Hammer-family processor.  Enables
-	  use of some extended instructions, and passes appropriate optimization
-	  flags to GCC.
+	  Select this for an AMD Opteron or Athlon64 Hammer-family processor. 
+	  Enables use of some extended instructions, and passes appropriate
+	  optimization flags to GCC.
 
 config MCRUSOE
 	bool "Crusoe"
@@ -256,9 +256,11 @@ config MPSC
 config MCORE2
 	bool "Core 2/newer Xeon"
 	help
-	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
-	  CPUs. You can distinguish newer from older Xeons by the CPU family
-	  in /proc/cpuinfo. Newer ones have 6 and older ones 15 (not a typo)
+
+	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and
+	  53xx) CPUs. You can distinguish newer from older Xeons by the CPU
+	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
+	  (not a typo)
 
 config GENERIC_CPU
 	bool "Generic-x86-64"
@@ -320,14 +322,14 @@ config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
 	depends on M686 || M586MMX || M586TSC || M586 || M486 || M386 || MGEODEGX1
 	help
-	  Old PentiumPro multiprocessor systems had errata that could cause memory
-	  operations to violate the x86 ordering standard in rare cases. Enabling this
-	  option will attempt to work around some (but not all) occurances of
-	  this problem, at the cost of much heavier spinlock and memory barrier
-	  operations.
+	  Old PentiumPro multiprocessor systems had errata that could cause
+	  memory operations to violate the x86 ordering standard in rare cases.
+	  Enabling this option will attempt to work around some (but not all)
+	  occurances of this problem, at the cost of much heavier spinlock and
+	  memory barrier operations.
 
-	  If unsure, say n here. Even distro kernels should think twice before enabling
-	  this: there are few systems, and an unlikely bug.
+	  If unsure, say n here. Even distro kernels should think twice before
+	  enabling this: there are few systems, and an unlikely bug.
 
 config X86_F00F_BUG
 	def_bool y
-- 
1.6.0.4

-- 
Regards/Gruss,
    Boris.
