Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbZGQAFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbZGQAFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbZGQAFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39111 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313AbZGQAFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>,
       Cliff Cai <cliff.cai@analog.com>, Robin Getz <robin.getz@analog.com>
Subject: [PATCH 03/21] Blackfin: update anomaly lists to match latest sheets/usage
Date: Thu, 16 Jul 2009 20:05:28 -0400
Message-Id: <1247789146-18786-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/include/mach/anomaly.h |    2 ++
 arch/blackfin/mach-bf527/include/mach/anomaly.h |    4 +++-
 arch/blackfin/mach-bf533/include/mach/anomaly.h |    1 +
 arch/blackfin/mach-bf537/include/mach/anomaly.h |    2 ++
 arch/blackfin/mach-bf538/include/mach/anomaly.h |    2 ++
 arch/blackfin/mach-bf548/include/mach/anomaly.h |    2 ++
 arch/blackfin/mach-bf561/include/mach/anomaly.h |    1 +
 7 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/anomaly.h b/arch/blackfin/mach-bf518/include/mach/anomaly.h
index 426e064..753ed81 100644
--- a/arch/blackfin/mach-bf518/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf518/include/mach/anomaly.h
@@ -82,6 +82,7 @@
 #define ANOMALY_05000179 (0)
 #define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
+#define ANOMALY_05000189 (0)
 #define ANOMALY_05000198 (0)
 #define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
@@ -117,6 +118,7 @@
 #define ANOMALY_05000357 (0)
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000364 (0)
 #define ANOMALY_05000371 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (0)
diff --git a/arch/blackfin/mach-bf527/include/mach/anomaly.h b/arch/blackfin/mach-bf527/include/mach/anomaly.h
index 0d63f74..c438ca8 100644
--- a/arch/blackfin/mach-bf527/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf527/include/mach/anomaly.h
@@ -176,6 +176,8 @@
 #define ANOMALY_05000443 (1)
 /* The WURESET Bit in the SYSCR Register is not Functional */
 #define ANOMALY_05000445 (1)
+/* USB DMA Short Packet Data Corruption */
+#define ANOMALY_05000450 (1)
 /* BCODE_QUICKBOOT, BCODE_ALLBOOT, and BCODE_FULLBOOT Settings in SYSCR Register Not Functional */
 #define ANOMALY_05000451 (1)
 /* Incorrect Default Hysteresis Setting for RESET, NMI, and BMODE Signals */
@@ -201,6 +203,7 @@
 #define ANOMALY_05000179 (0)
 #define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
+#define ANOMALY_05000189 (0)
 #define ANOMALY_05000198 (0)
 #define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
@@ -238,6 +241,5 @@
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000447 (0)
 #define ANOMALY_05000448 (0)
-#define ANOMALY_05000450 (0)
 
 #endif
diff --git a/arch/blackfin/mach-bf533/include/mach/anomaly.h b/arch/blackfin/mach-bf533/include/mach/anomaly.h
index 70a0ad6..cd83db2 100644
--- a/arch/blackfin/mach-bf533/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf533/include/mach/anomaly.h
@@ -335,6 +335,7 @@
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (1)
 #define ANOMALY_05000362 (1)
+#define ANOMALY_05000364 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000389 (0)
diff --git a/arch/blackfin/mach-bf537/include/mach/anomaly.h b/arch/blackfin/mach-bf537/include/mach/anomaly.h
index 57c128c..e66aa13 100644
--- a/arch/blackfin/mach-bf537/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf537/include/mach/anomaly.h
@@ -167,6 +167,7 @@
 #define ANOMALY_05000179 (0)
 #define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
+#define ANOMALY_05000189 (0)
 #define ANOMALY_05000198 (0)
 #define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
@@ -186,6 +187,7 @@
 #define ANOMALY_05000353 (1)
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000364 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000389 (0)
diff --git a/arch/blackfin/mach-bf538/include/mach/anomaly.h b/arch/blackfin/mach-bf538/include/mach/anomaly.h
index c97acdf..451cf8a 100644
--- a/arch/blackfin/mach-bf538/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf538/include/mach/anomaly.h
@@ -137,6 +137,7 @@
 #define ANOMALY_05000158 (0)
 #define ANOMALY_05000171 (0)
 #define ANOMALY_05000182 (0)
+#define ANOMALY_05000189 (0)
 #define ANOMALY_05000198 (0)
 #define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
@@ -160,6 +161,7 @@
 #define ANOMALY_05000353 (1)
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000364 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000389 (0)
diff --git a/arch/blackfin/mach-bf548/include/mach/anomaly.h b/arch/blackfin/mach-bf548/include/mach/anomaly.h
index 18a4cd2..cd040fe 100644
--- a/arch/blackfin/mach-bf548/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf548/include/mach/anomaly.h
@@ -195,6 +195,7 @@
 #define ANOMALY_05000179 (0)
 #define ANOMALY_05000182 (0)
 #define ANOMALY_05000183 (0)
+#define ANOMALY_05000189 (0)
 #define ANOMALY_05000198 (0)
 #define ANOMALY_05000202 (0)
 #define ANOMALY_05000215 (0)
@@ -226,6 +227,7 @@
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000362 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000364 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000400 (0)
 #define ANOMALY_05000412 (0)
diff --git a/arch/blackfin/mach-bf561/include/mach/anomaly.h b/arch/blackfin/mach-bf561/include/mach/anomaly.h
index 94b8e27..a5312b2 100644
--- a/arch/blackfin/mach-bf561/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf561/include/mach/anomaly.h
@@ -288,6 +288,7 @@
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000353 (1)
+#define ANOMALY_05000364 (0)
 #define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000389 (0)
-- 
1.6.3.3

