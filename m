Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYHNPPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYHNPPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHNPPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:15:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47247 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYHNPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:15:31 -0400
Date: Thu, 14 Aug 2008 17:16:50 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Trivial patch monkey <trivial@kernel.org>
Subject: arch/x86/Kconfig: clean up, experimental adjustement
Message-ID: <20080814151650.GA23106@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adjust experimental tags in Kconfig, update config to notice that
i386/x86_64 is now single architecture.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit ea977ecb4f994b0dc2e09cab3dbba87aad030d99
tree 95db6fca54f0aa0bbe0e9cb7f83e87b56c004413
parent a1d270d84974135ba67bc83fd6498bd580ada373
author Pavel <pavel@amd.ucw.cz> Thu, 14 Aug 2008 17:15:59 +0200
committer Pavel <pavel@amd.ucw.cz> Thu, 14 Aug 2008 17:15:59 +0200

 arch/x86/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d598250..7026ee0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -950,9 +950,9 @@ config NUMA
 	  local memory controller of the CPU and add some more
 	  NUMA awareness to the kernel.
 
-	  For i386 this is currently highly experimental and should be only
+	  For 32-bit this is currently highly experimental and should be only
 	  used for kernel development. It might also cause boot failures.
-	  For x86_64 this is recommended on all multiprocessor Opteron systems.
+	  For 64-bit this is recommended on all multiprocessor Opteron systems.
 	  If the system is EM64T, you should say N unless your system is
 	  EM64T NUMA.
 
@@ -1219,7 +1219,7 @@ config SECCOMP
 	  If unsure, say Y. Only embedded should say N here.
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
+	bool "Enable -fstack-protector buffer overflow detection (BROKEN)"
 	depends on X86_64 && EXPERIMENTAL && BROKEN
 	help
          This option turns on the -fstack-protector GCC feature. This
@@ -1262,7 +1262,7 @@ config KEXEC
 	  strongly in flux, so no good recommendation can be made.
 
 config CRASH_DUMP
-	bool "kernel crash dumps (EXPERIMENTAL)"
+	bool "kernel crash dumps"
 	depends on X86_64 || (X86_32 && HIGHMEM)
 	help
 	  Generate crash dump after being started by kexec.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
