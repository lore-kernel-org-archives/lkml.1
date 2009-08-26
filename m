Return-Path: <linux-kernel-owner+w=401wt.eu-S932269AbZHZGlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbZHZGlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZHZGlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:41:03 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:43721
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756810AbZHZGlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:41:01 -0400
Subject: Subject: [PATCH 06/33] score: create head files
	emergency-restart.h kdebug.h kmap_types.h posix_types.h swab.h types.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:11:58 +0800
Message-Id: <1251267118.3073.3.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1dccc2a42306157981b3dd296822ce6dc1988c2e Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:04:58 +0800
Subject: [PATCH 06/33] score: create head files emergency-restart.h kdebug.h kmap_types.h posix_types.h swab.h types.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/emergency-restart.h |    6 ++++++
 arch/score/include/asm/kdebug.h            |    6 ++++++
 arch/score/include/asm/kmap_types.h        |    6 ++++++
 arch/score/include/asm/posix_types.h       |    6 ++++++
 arch/score/include/asm/swab.h              |    6 ++++++
 arch/score/include/asm/types.h             |    6 ++++++
 6 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/emergency-restart.h
 create mode 100644 arch/score/include/asm/kdebug.h
 create mode 100644 arch/score/include/asm/kmap_types.h
 create mode 100644 arch/score/include/asm/posix_types.h
 create mode 100644 arch/score/include/asm/swab.h
 create mode 100644 arch/score/include/asm/types.h

diff --git a/arch/score/include/asm/emergency-restart.h b/arch/score/include/asm/emergency-restart.h
new file mode 100644
index 0000000..ca31e98
--- /dev/null
+++ b/arch/score/include/asm/emergency-restart.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_EMERGENCY_RESTART_H
+#define _ASM_SCORE_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* _ASM_SCORE_EMERGENCY_RESTART_H */
diff --git a/arch/score/include/asm/kdebug.h b/arch/score/include/asm/kdebug.h
new file mode 100644
index 0000000..a666e51
--- /dev/null
+++ b/arch/score/include/asm/kdebug.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_KDEBUG_H
+#define _ASM_SCORE_KDEBUG_H
+
+#include <asm-generic/kdebug.h>
+
+#endif /* _ASM_SCORE_KDEBUG_H */
diff --git a/arch/score/include/asm/kmap_types.h b/arch/score/include/asm/kmap_types.h
new file mode 100644
index 0000000..6c46eb5
--- /dev/null
+++ b/arch/score/include/asm/kmap_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_KMAP_TYPES_H
+#define _ASM_SCORE_KMAP_TYPES_H
+
+#include <asm-generic/kmap_types.h>
+
+#endif /* _ASM_SCORE_KMAP_TYPES_H */
diff --git a/arch/score/include/asm/posix_types.h b/arch/score/include/asm/posix_types.h
new file mode 100644
index 0000000..b88acf8
--- /dev/null
+++ b/arch/score/include/asm/posix_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_POSIX_TYPES_H
+#define _ASM_SCORE_POSIX_TYPES_H
+
+#include <asm-generic/posix_types.h>
+
+#endif /* _ASM_SCORE_POSIX_TYPES_H */
diff --git a/arch/score/include/asm/swab.h b/arch/score/include/asm/swab.h
new file mode 100644
index 0000000..fadc3cc
--- /dev/null
+++ b/arch/score/include/asm/swab.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SWAB_H
+#define _ASM_SCORE_SWAB_H
+
+#include <asm-generic/swab.h>
+
+#endif /* _ASM_SCORE_SWAB_H */
diff --git a/arch/score/include/asm/types.h b/arch/score/include/asm/types.h
new file mode 100644
index 0000000..2140032
--- /dev/null
+++ b/arch/score/include/asm/types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TYPES_H
+#define _ASM_SCORE_TYPES_H
+
+#include <asm-generic/types.h>
+
+#endif /* _ASM_SCORE_TYPES_H */
-- 
1.6.2



