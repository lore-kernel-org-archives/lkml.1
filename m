Return-Path: <linux-kernel-owner+w=401wt.eu-S934573AbXHHDlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573AbXHHDlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936057AbXHHDg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:29 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:9964 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934639AbXHHDfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:52 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="36639274:sNHT453057290"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 09/12] Blackfin arch: scrub remaining ASSEMBLY usage since the switch to __ASSEMBLY__
Date: Wed,  8 Aug 2007 11:35:34 +0800
Message-Id: <11865441414148-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/mach-bf533/blackfin.h |    2 +-
 include/asm-blackfin/mach-bf537/blackfin.h |    2 +-
 include/asm-blackfin/mach-bf548/blackfin.h |    2 +-
 include/asm-blackfin/mach-bf561/blackfin.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-blackfin/mach-bf533/blackfin.h b/include/asm-blackfin/mach-bf533/blackfin.h
index e438449..f3b240a 100644
--- a/include/asm-blackfin/mach-bf533/blackfin.h
+++ b/include/asm-blackfin/mach-bf533/blackfin.h
@@ -38,7 +38,7 @@
 #include "defBF532.h"
 #include "anomaly.h"
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF532.h"
 #endif
 
diff --git a/include/asm-blackfin/mach-bf537/blackfin.h b/include/asm-blackfin/mach-bf537/blackfin.h
index bbd9705..f196588 100644
--- a/include/asm-blackfin/mach-bf537/blackfin.h
+++ b/include/asm-blackfin/mach-bf537/blackfin.h
@@ -43,7 +43,7 @@
 #include "defBF537.h"
 #endif
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF534.h"
 
 /* UART 0*/
diff --git a/include/asm-blackfin/mach-bf548/blackfin.h b/include/asm-blackfin/mach-bf548/blackfin.h
index 791218f..19e84dd 100644
--- a/include/asm-blackfin/mach-bf548/blackfin.h
+++ b/include/asm-blackfin/mach-bf548/blackfin.h
@@ -54,7 +54,7 @@
 #include "defBF549.h"
 #endif
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #ifdef CONFIG_BF542
 #include "cdefBF542.h"
 #endif
diff --git a/include/asm-blackfin/mach-bf561/blackfin.h b/include/asm-blackfin/mach-bf561/blackfin.h
index 2537c84..562aee3 100644
--- a/include/asm-blackfin/mach-bf561/blackfin.h
+++ b/include/asm-blackfin/mach-bf561/blackfin.h
@@ -38,7 +38,7 @@
 #include "defBF561.h"
 #include "anomaly.h"
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF561.h"
 #endif
 
-- 
1.5.2
