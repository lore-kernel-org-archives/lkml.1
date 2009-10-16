Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbZJPRVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbZJPRVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZJPRVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:21:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:40561 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501AbZJPRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:21:45 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] powerpc: Limit memory hotplug support to PPC64 Book-3S machines
Date: Fri, 16 Oct 2009 12:21:36 -0500
Message-Id: <1255713699-21852-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255713699-21852-2-git-send-email-galak@kernel.crashing.org>
References: <1255713699-21852-1-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-2-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 mm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 57963c6..7ca3777 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -129,7 +129,7 @@ config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on HOTPLUG && !(HIBERNATION && !S390) && ARCH_ENABLE_MEMORY_HOTPLUG
-	depends on (IA64 || X86 || PPC64 || SUPERH || S390)
+	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
 
 comment "Memory hotplug is currently incompatible with Software Suspend"
 	depends on SPARSEMEM && HOTPLUG && HIBERNATION && !S390
-- 
1.6.0.6

