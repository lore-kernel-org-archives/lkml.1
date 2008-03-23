Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbYCWImY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbYCWImY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759371AbYCWIKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:44 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2310 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759909AbYCWIKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:40 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 146/148] include/asm-x86/vsyscall.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:04:01 -0700
Message-Id: <1206259443-13210-147-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/vsyscall.h |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/asm-x86/vsyscall.h b/include/asm-x86/vsyscall.h
index 17b3700..8a53b1c 100644
--- a/include/asm-x86/vsyscall.h
+++ b/include/asm-x86/vsyscall.h
@@ -11,20 +11,25 @@ enum vsyscall_num {
 #define VSYSCALL_SIZE 1024
 #define VSYSCALL_END (-2UL << 20)
 #define VSYSCALL_MAPPED_PAGES 1
-#define VSYSCALL_ADDR(vsyscall_nr) (VSYSCALL_START+VSYSCALL_SIZE*(vsyscall_nr))
+#define VSYSCALL_ADDR(vsyscall_nr)				\
+	(VSYSCALL_START + VSYSCALL_SIZE * (vsyscall_nr))
 
 #ifdef __KERNEL__
 #include <linux/seqlock.h>
 
-#define __section_vgetcpu_mode __attribute__ ((unused, __section__ (".vgetcpu_mode"), aligned(16)))
-#define __section_jiffies __attribute__ ((unused, __section__ (".jiffies"), aligned(16)))
+#define __section_vgetcpu_mode						\
+	__attribute__ ((unused, __section__ (".vgetcpu_mode"), aligned(16)))
+#define __section_jiffies						\
+	__attribute__ ((unused, __section__ (".jiffies"), aligned(16)))
 
 /* Definitions for CONFIG_GENERIC_TIME definitions */
-#define __section_vsyscall_gtod_data __attribute__ \
-	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
-#define __section_vsyscall_clock __attribute__ \
-	((unused, __section__ (".vsyscall_clock"),aligned(16)))
-#define __vsyscall_fn __attribute__ ((unused,__section__(".vsyscall_fn")))
+#define __section_vsyscall_gtod_data \
+	__attribute__ ((unused, __section__ (".vsyscall_gtod_data"),	\
+			aligned(16)))
+#define __section_vsyscall_clock					\
+	__attribute__ ((unused, __section__ (".vsyscall_clock"), aligned(16)))
+#define __vsyscall_fn							\
+	__attribute__ ((unused, __section__(".vsyscall_fn")))
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
-- 
1.5.4.rc2

