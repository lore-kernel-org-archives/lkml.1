Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZJXBJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZJXBJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZJXBEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZJXBEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:13 -0400
Date: Sat, 24 Oct 2009 01:03:34 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255973491-11626-1-git-send-email-acme@redhat.com>
References: <1255973491-11626-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] perf tools: Add bunch of missing headers to LIB_H
Message-ID: <tip-79b9ad361be8c6f3eeea97dd3883e8bcfa989333@git.kernel.org>
Git-Commit-ID: 79b9ad361be8c6f3eeea97dd3883e8bcfa989333
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79b9ad361be8c6f3eeea97dd3883e8bcfa989333
Gitweb:     http://git.kernel.org/tip/79b9ad361be8c6f3eeea97dd3883e8bcfa989333
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 19 Oct 2009 15:31:31 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Oct 2009 03:00:36 +0200

perf tools: Add bunch of missing headers to LIB_H

Build dependencies were not properly mapped out.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1255973491-11626-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
