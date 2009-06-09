Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZFIHKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZFIHKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZFIHKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:10:33 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58710 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZFIHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:10:32 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 04/27] score: create head files bitops.h bitsperlong.h bug.h bugs.h
 byteorder.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFBB948A5B.D38E1AE1-ON482575D0.00233280-482575D0.0023A73C@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:25:08 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:25:09,
	Serialize complete at 2009/06/09 ?? 02:25:09
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ea24b4bd75b80d22203139a9aab7872be284d52d Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:06 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/bitops.h      |   16 ++++++++++++++++
 arch/score/include/asm/bitsperlong.h |    6 ++++++
 arch/score/include/asm/bug.h         |    6 ++++++
 arch/score/include/asm/bugs.h        |    6 ++++++
 arch/score/include/asm/byteorder.h   |    6 ++++++
 5 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/bitops.h
 create mode 100644 arch/score/include/asm/bitsperlong.h
 create mode 100644 arch/score/include/asm/bug.h
 create mode 100644 arch/score/include/asm/bugs.h
 create mode 100644 arch/score/include/asm/byteorder.h

diff --git a/arch/score/include/asm/bitops.h 
b/arch/score/include/asm/bitops.h
new file mode 100644
index 0000000..2763b05
--- /dev/null
+++ b/arch/score/include/asm/bitops.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_SCORE_BITOPS_H
+#define _ASM_SCORE_BITOPS_H
+
+#include <asm/byteorder.h> /* swab32 */
+#include <asm/system.h> /* save_flags */
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()     barrier()
+#define smp_mb__after_clear_bit()      barrier()
+
+#include <asm-generic/bitops.h>
+#include <asm-generic/bitops/__fls.h>
+
+#endif /* _ASM_SCORE_BITOPS_H */
diff --git a/arch/score/include/asm/bitsperlong.h 
b/arch/score/include/asm/bitsperlong.h
new file mode 100644
index 0000000..86ff337
--- /dev/null
+++ b/arch/score/include/asm/bitsperlong.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BITSPERLONG_H
+#define _ASM_SCORE_BITSPERLONG_H
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* _ASM_SCORE_BITSPERLONG_H */
diff --git a/arch/score/include/asm/bug.h b/arch/score/include/asm/bug.h
new file mode 100644
index 0000000..bb76a33
--- /dev/null
+++ b/arch/score/include/asm/bug.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BUG_H
+#define _ASM_SCORE_BUG_H
+
+#include <asm-generic/bug.h>
+
+#endif /* _ASM_SCORE_BUG_H */
diff --git a/arch/score/include/asm/bugs.h b/arch/score/include/asm/bugs.h
new file mode 100644
index 0000000..a062e10
--- /dev/null
+++ b/arch/score/include/asm/bugs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BUGS_H
+#define _ASM_SCORE_BUGS_H
+
+#include <asm-generic/bugs.h>
+
+#endif /* _ASM_SCORE_BUGS_H */
diff --git a/arch/score/include/asm/byteorder.h 
b/arch/score/include/asm/byteorder.h
new file mode 100644
index 0000000..88cbebc
--- /dev/null
+++ b/arch/score/include/asm/byteorder.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BYTEORDER_H
+#define _ASM_SCORE_BYTEORDER_H
+
+#include <linux/byteorder/little_endian.h>
+
+#endif /* _ASM_SCORE_BYTEORDER_H */
-- 
1.6.2

