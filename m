Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYFYVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYFYVtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYFYVtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:49:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbYFYVtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:49:15 -0400
From: Bernhard Walle <bwalle@suse.de>
To: vgoyal@redhat.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Date: Wed, 25 Jun 2008 23:49:52 +0200
Message-Id: <1214430592-18043-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would suggest to remove the "experimental" status from Kdump.
Kdump is now in the kernel since a long time and used by Enterprise
distributions. I don't think that "experimental" is true any more.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/Kconfig |    1 -
 fs/Kconfig       |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e0edaaa..f4f255b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1190,7 +1190,6 @@ config KEXEC
 
 config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
 	depends on X86_64 || (X86_32 && HIGHMEM)
 	help
 	  Generate crash dump after being started by kexec.
diff --git a/fs/Kconfig b/fs/Kconfig
index cf12c40..b2252a4 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -930,7 +930,7 @@ config PROC_KCORE
 
 config PROC_VMCORE
         bool "/proc/vmcore support (EXPERIMENTAL)"
-        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
+        depends on PROC_FS && CRASH_DUMP
 	default y
         help
         Exports the dump image of crashed kernel in ELF format.
-- 
1.5.4.5

