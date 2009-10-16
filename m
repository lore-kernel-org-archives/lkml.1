Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbZJPRW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbZJPRW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176AbZJPRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:21:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:40558 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953AbZJPRVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:21:43 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] powerpc: Limit hugetlbfs support to PPC64 Book-3S machines
Date: Fri, 16 Oct 2009 12:21:35 -0500
Message-Id: <1255713699-21852-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255713699-21852-1-git-send-email-galak@kernel.crashing.org>
References: <1255713699-21852-1-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 fs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index d4bf8ca..f93d0ed 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -135,7 +135,7 @@ config TMPFS_POSIX_ACL
 
 config HUGETLBFS
 	bool "HugeTLB file system support"
-	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || \
+	depends on X86 || IA64 || PPC_BOOK3S_64 || SPARC64 || (SUPERH && MMU) || \
 		   (S390 && 64BIT) || SYS_SUPPORTS_HUGETLBFS || BROKEN
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
-- 
1.6.0.6

