Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZFIGfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZFIGfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbZFIGfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:35:17 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:36825 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZFIGfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:35:16 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 11/27] score: create head files Kbuild kdebug.h kmap_types.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFE384AB29.2D64F5E0-ON482575D0.0023965E-482575D0.00240633@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:29:11 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:29:11,
	Serialize complete at 2009/06/09 ?? 02:29:11
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2a4a35ab87d3d1d98ed4fd07f79fbd0811568707 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:10 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/Kbuild       |    3 +++
 arch/score/include/asm/kdebug.h     |    6 ++++++
 arch/score/include/asm/kmap_types.h |    6 ++++++
 3 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/Kbuild
 create mode 100644 arch/score/include/asm/kdebug.h
 create mode 100644 arch/score/include/asm/kmap_types.h

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
new file mode 100644
index 0000000..b367abd
--- /dev/null
+++ b/arch/score/include/asm/Kbuild
@@ -0,0 +1,3 @@
+include include/asm-generic/Kbuild.asm
+
+header-y +=
diff --git a/arch/score/include/asm/kdebug.h 
b/arch/score/include/asm/kdebug.h
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
diff --git a/arch/score/include/asm/kmap_types.h 
b/arch/score/include/asm/kmap_types.h
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
-- 
1.6.2

