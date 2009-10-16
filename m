Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbZJPRW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbZJPRW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZJPRWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:22:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:40565 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbZJPRVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:21:47 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] powerpc: cleanup init/Kconfig
Date: Fri, 16 Oct 2009 12:21:37 -0500
Message-Id: <1255713699-21852-4-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255713699-21852-3-git-send-email-galak@kernel.crashing.org>
References: <1255713699-21852-1-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-2-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-3-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We dont need to depend on PPC64 explicitly as all powerpc platforms
(32-bit and 64-bit) define PPC now.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 09c5c64..f515864 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -297,7 +297,7 @@ config AUDIT
 
 config AUDITSYSCALL
 	bool "Enable system-call auditing support"
-	depends on AUDIT && (X86 || PPC || PPC64 || S390 || IA64 || UML || SPARC64|| SUPERH)
+	depends on AUDIT && (X86 || PPC || S390 || IA64 || UML || SPARC64 || SUPERH)
 	default y if SECURITY_SELINUX
 	help
 	  Enable low-overhead system-call auditing infrastructure that
-- 
1.6.0.6

