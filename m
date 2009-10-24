Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZJXBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZJXBEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZJXBEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:51673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZJXBEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:32 -0400
Date: Sat, 24 Oct 2009 01:03:32 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255972296-11500-1-git-send-email-acme@redhat.com>
References: <1255972296-11500-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf tools: Add missing tools/perf/util/include/string.h
Message-ID: <tip-20639c15d2e78f180d398a6b6422880fac3258bb@git.kernel.org>
Git-Commit-ID: 20639c15d2e78f180d398a6b6422880fac3258bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20639c15d2e78f180d398a6b6422880fac3258bb
Gitweb:     http://git.kernel.org/tip/20639c15d2e78f180d398a6b6422880fac3258bb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 19 Oct 2009 15:11:36 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 02:59:34 +0200

perf tools: Add missing tools/perf/util/include/string.h

To cure a bunch of:

In file included from util/include/linux/bitmap.h:1,
                 from util/header.h:8,
                 from builtin-trace.c:7:
util/include/../../../../include/linux/bitmap.h:8:26: error:
linux/string.h: No such file or directory make: ***
[builtin-trace.o] Error 1 make: *** Waiting for unfinished
jobs....

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1255972296-11500-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile                    |    1 +
 tools/perf/util/include/linux/string.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

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
