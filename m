Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZEAAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZEAAT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765388AbZEAADa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:30 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763713AbZEAAD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:27 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, "David S. Miller" <davem@davemloft.net>,
       sparclinux@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/4] sparc: convert to new generic read_mostly support.
Date: Thu, 30 Apr 2009 19:58:53 -0400
Message-Id: <1241135933-9913-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135933-9913-4-git-send-email-tabbott@mit.edu>
References: <1241135933-9913-1-git-send-email-tabbott@mit.edu>
 <1241135933-9913-2-git-send-email-tabbott@mit.edu>
 <1241135933-9913-3-git-send-email-tabbott@mit.edu>
 <1241135933-9913-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/Kconfig             |    3 +++
 arch/sparc/include/asm/cache.h |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index cc12cd4..fbdeded 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -127,6 +127,9 @@ config OF
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y if SPARC64
 
+config HAVE_READ_MOSTLY_DATA
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/sparc/include/asm/cache.h b/arch/sparc/include/asm/cache.h
index 41f85ae..e614736 100644
--- a/arch/sparc/include/asm/cache.h
+++ b/arch/sparc/include/asm/cache.h
@@ -19,8 +19,6 @@
 
 #define SMP_CACHE_BYTES (1 << SMP_CACHE_BYTES_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
-
 #ifdef CONFIG_SPARC32
 #include <asm/asi.h>
 
-- 
1.6.2.1

