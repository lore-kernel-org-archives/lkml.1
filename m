Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbZJSRLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbZJSRLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZJSRLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:11:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZJSRLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:11:42 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tools: Add missing tools/perf/util/include/string.h
Date: Mon, 19 Oct 2009 15:11:36 -0200
Message-Id: <1255972296-11500-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To cure a bunch of:

In file included from util/include/linux/bitmap.h:1,
                 from util/header.h:8,
                 from builtin-trace.c:7:
util/include/../../../../include/linux/bitmap.h:8:26: error: linux/string.h: No such file or directory
make: *** [builtin-trace.o] Error 1
make: *** Waiting for unfinished jobs....

Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                    |    1 +
 tools/perf/util/include/linux/string.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/linux/string.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index db89a6d..3b154f1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -329,6 +329,7 @@ LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
 LIB_H += util/include/linux/list.h
+LIB_H += util/include/linux/string.h
 LIB_H += perf.h
 LIB_H += util/event.h
 LIB_H += util/types.h
diff --git a/tools/perf/util/include/linux/string.h b/tools/perf/util/include/linux/string.h
new file mode 100644
index 0000000..3b2f590
--- /dev/null
+++ b/tools/perf/util/include/linux/string.h
@@ -0,0 +1 @@
+#include <string.h>
-- 
1.5.5.1

