Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZK3TuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZK3TuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZK3TuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:50:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:34167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZK3TuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:50:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 1/1] MIPS: Wire up recvmmsg syscall
Date: Mon, 30 Nov 2009 17:50:15 -0200
Message-Id: <1259610615-23996-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/mips/include/asm/unistd.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index 8c9dfa9..65c679e 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -355,16 +355,17 @@
 #define __NR_rt_tgsigqueueinfo		(__NR_Linux + 332)
 #define __NR_perf_event_open		(__NR_Linux + 333)
 #define __NR_accept4			(__NR_Linux + 334)
+#define __NR_recvmmsg			(__NR_Linux + 335)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		334
+#define __NR_Linux_syscalls		335
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		334
+#define __NR_O32_Linux_syscalls		335
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -666,16 +667,17 @@
 #define __NR_rt_tgsigqueueinfo		(__NR_Linux + 291)
 #define __NR_perf_event_open		(__NR_Linux + 292)
 #define __NR_accept4			(__NR_Linux + 293)
+#define __NR_recvmmsg			(__NR_Linux + 294)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		293
+#define __NR_Linux_syscalls		294
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		293
+#define __NR_64_Linux_syscalls		294
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -981,16 +983,17 @@
 #define __NR_rt_tgsigqueueinfo		(__NR_Linux + 295)
 #define __NR_perf_event_open		(__NR_Linux + 296)
 #define __NR_accept4			(__NR_Linux + 297)
+#define __NR_recvmmsg			(__NR_Linux + 298)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		297
+#define __NR_Linux_syscalls		298
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		297
+#define __NR_N32_Linux_syscalls		298
 
 #ifdef __KERNEL__
 
-- 
1.6.2.5

