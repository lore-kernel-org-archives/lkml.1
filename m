Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbXJVCr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbXJVCr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXJVCrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:47:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47840 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493AbXJVCri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:47:38 -0400
Date: Mon, 22 Oct 2007 04:48:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [2.6 patch] x86: add instrumentation menu
Message-ID: <20071022024808.GK30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9 was incomplete 
due to a clash with the x86 architecture merge.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/i386/Kconfig         |    2 ++
 arch/x86/oprofile/Kconfig |   17 -----------------
 arch/x86_64/Kconfig       |    2 ++
 3 files changed, 4 insertions(+), 17 deletions(-)

e66850f5417ad721e75bf575b6ec49d7aec0af04 
diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index f6e44fc..9e8a74f 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -1258,6 +1258,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/i386/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/x86/oprofile/Kconfig b/arch/x86/oprofile/Kconfig
deleted file mode 100644
index d8a8408..0000000
--- a/arch/x86/oprofile/Kconfig
+++ /dev/null
@@ -1,17 +0,0 @@
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-	  
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index aab25f3..106d5d5 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -801,6 +801,8 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/x86_64/Kconfig.debug"
 
 source "security/Kconfig"

