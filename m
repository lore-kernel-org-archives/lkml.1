Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZFIGxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZFIGxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZFIGxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:53:00 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:35512 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZFIGw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:52:59 -0400
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 02:52:59 EDT
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 12/27] score: create head files linkage.h local.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF4F913F1C.49F95FA2-ON482575D0.0023A280-482575D0.00241426@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:29:47 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:29:47,
	Serialize complete at 2009/06/09 ?? 02:29:47
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9a73d300e241dca5f461b0ce533294d667a1aa61 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:10 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/linkage.h |    4 ++++
 arch/score/include/asm/local.h   |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/linkage.h
 create mode 100644 arch/score/include/asm/local.h

diff --git a/arch/score/include/asm/linkage.h 
b/arch/score/include/asm/linkage.h
new file mode 100644
index 0000000..2580fbb
--- /dev/null
+++ b/arch/score/include/asm/linkage.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_LINKAGE_H
+#define _ASM_SCORE_LINKAGE_H
+
+#endif /* _ASM_SCORE_LINKAGE_H */
diff --git a/arch/score/include/asm/local.h 
b/arch/score/include/asm/local.h
new file mode 100644
index 0000000..7e02f13
--- /dev/null
+++ b/arch/score/include/asm/local.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_LOCAL_H
+#define _ASM_SCORE_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* _ASM_SCORE_LOCAL_H */
-- 
1.6.2

