Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZJSRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZJSRbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZJSRbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:31:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbZJSRbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:31:35 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tools: Add bunch of missing headers to LIB_H
Date: Mon, 19 Oct 2009 15:31:31 -0200
Message-Id: <1255973491-11626-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3b154f1..64c6b7b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -328,8 +328,25 @@ LIB_FILE=libperf.a
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
+LIB_H += util/include/linux/bitmap.h
+LIB_H += util/include/linux/bitops.h
+LIB_H += util/include/linux/compiler.h
+LIB_H += util/include/linux/ctype.h
+LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
+LIB_H += util/include/linux/module.h
+LIB_H += util/include/linux/poison.h
+LIB_H += util/include/linux/prefetch.h
+LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/string.h
+LIB_H += util/include/linux/types.h
+LIB_H += util/include/asm/asm-offsets.h
+LIB_H += util/include/asm/bitops.h
+LIB_H += util/include/asm/byteorder.h
+LIB_H += util/include/asm/swab.h
+LIB_H += util/include/asm/system.h
+LIB_H += util/include/asm/types.h
+LIB_H += util/include/asm/uaccess.h
 LIB_H += perf.h
 LIB_H += util/event.h
 LIB_H += util/types.h
-- 
1.5.5.1

