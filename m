Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbZEAAVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbZEAAVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765430AbZEAADf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765335AbZEAADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:31 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, linux-sh@vger.kernel.org
Subject: [PATCH 7/7] sh: convert to new generic read_mostly support.
Date: Thu, 30 Apr 2009 19:58:03 -0400
Message-Id: <1241135883-9766-8-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135883-9766-7-git-send-email-tabbott@mit.edu>
References: <1241135883-9766-1-git-send-email-tabbott@mit.edu>
 <1241135883-9766-2-git-send-email-tabbott@mit.edu>
 <1241135883-9766-3-git-send-email-tabbott@mit.edu>
 <1241135883-9766-4-git-send-email-tabbott@mit.edu>
 <1241135883-9766-5-git-send-email-tabbott@mit.edu>
 <1241135883-9766-6-git-send-email-tabbott@mit.edu>
 <1241135883-9766-7-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/Kconfig             |    3 +++
 arch/sh/include/asm/cache.h |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index e7390dd..efafd78 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -137,6 +137,9 @@ config ARCH_HAS_DEFAULT_IDLE
 config IO_TRAPPED
 	bool
 
+config HAVE_READ_MOSTLY_DATA
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/sh/include/asm/cache.h b/arch/sh/include/asm/cache.h
index 02df18e..0d44279 100644
--- a/arch/sh/include/asm/cache.h
+++ b/arch/sh/include/asm/cache.h
@@ -14,8 +14,6 @@
 
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
-
 #ifndef __ASSEMBLY__
 struct cache_info {
 	unsigned int ways;		/* Number of cache ways */
-- 
1.6.2.1

