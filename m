Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYFZHWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYFZHWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYFZHWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:22:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:47113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYFZHWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:22:44 -0400
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Date: Thu, 26 Jun 2008 09:23:21 +0200
Message-Id: <1214465001-12338-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080625221635.GD32344@redhat.com>
References: <20080625221635.GD32344@redhat.com>
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

