Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZHZGcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZHZGcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZHZGcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:32:18 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:40347
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbZHZGcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:32:17 -0400
Subject: Subject: [PATCH 15/33] score: create head files sigcontext.h
	siginfo.h signal.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:21:25 +0800
Message-Id: <1251267685.3073.22.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6f967d36d4d7bb4802de0fd269bf469160a425ff Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:03 +0800
Subject: [PATCH 15/33] score: create head files sigcontext.h siginfo.h signal.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/sigcontext.h |   22 ++++++++++++++++++++++
 arch/score/include/asm/siginfo.h    |    6 ++++++
 arch/score/include/asm/signal.h     |    6 ++++++
 3 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/sigcontext.h
 create mode 100644 arch/score/include/asm/siginfo.h
 create mode 100644 arch/score/include/asm/signal.h

diff --git a/arch/score/include/asm/sigcontext.h b/arch/score/include/asm/sigcontext.h
new file mode 100644
index 0000000..5ffda39
--- /dev/null
+++ b/arch/score/include/asm/sigcontext.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_SCORE_SIGCONTEXT_H
+#define _ASM_SCORE_SIGCONTEXT_H
+
+/*
+ * Keep this struct definition in sync with the sigcontext fragment
+ * in arch/score/tools/offset.c
+ */
+struct sigcontext {
+	unsigned int		sc_regmask;
+	unsigned int		sc_psr;
+	unsigned int		sc_condition;
+	unsigned long		sc_pc;
+	unsigned long		sc_regs[32];
+	unsigned int		sc_ssflags;
+	unsigned int		sc_mdceh;
+	unsigned int		sc_mdcel;
+	unsigned int		sc_ecr;
+	unsigned long		sc_ema;
+	unsigned long		sc_sigset[4];
+};
+
+#endif /* _ASM_SCORE_SIGCONTEXT_H */
diff --git a/arch/score/include/asm/siginfo.h b/arch/score/include/asm/siginfo.h
new file mode 100644
index 0000000..87ca356
--- /dev/null
+++ b/arch/score/include/asm/siginfo.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SIGINFO_H
+#define _ASM_SCORE_SIGINFO_H
+
+#include <asm-generic/siginfo.h>
+
+#endif /* _ASM_SCORE_SIGINFO_H */
diff --git a/arch/score/include/asm/signal.h b/arch/score/include/asm/signal.h
new file mode 100644
index 0000000..2605bc0
--- /dev/null
+++ b/arch/score/include/asm/signal.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SIGNAL_H
+#define _ASM_SCORE_SIGNAL_H
+
+#include <asm-generic/signal.h>
+
+#endif /* _ASM_SCORE_SIGNAL_H */
-- 
1.6.2



