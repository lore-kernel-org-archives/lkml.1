Return-Path: <linux-kernel-owner+w=401wt.eu-S1761809AbZLPITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761809AbZLPITy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934760AbZLPITv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:19:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:60264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761769AbZLPITr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:19:47 -0500
Date: Wed, 16 Dec 2009 08:18:52 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/lock] perf: Add util/include/linuxhash.h to include hash.h of kernel
Message-ID: <tip-7485634cae6a70a07f14e9f8a05407363a3cb44b@git.kernel.org>
Git-Commit-ID: 7485634cae6a70a07f14e9f8a05407363a3cb44b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7485634cae6a70a07f14e9f8a05407363a3cb44b
Gitweb:     http://git.kernel.org/tip/7485634cae6a70a07f14e9f8a05407363a3cb44b
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 16 Dec 2009 12:28:24 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 08:48:57 +0100

perf: Add util/include/linuxhash.h to include hash.h of kernel

linux/hash.h, hash header of kernel, is also useful for perf.

util/include/linuxhash.h includes linux/hash.h, so we can use
hash facilities (e.g. hash_long()) in perf now.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile                  |    1 +
 tools/perf/util/include/linux/hash.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 28b0258..aad2693 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -328,6 +328,7 @@ LIB_FILE=libperf.a
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
+LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += util/include/linux/bitops.h
diff --git a/tools/perf/util/include/linux/hash.h b/tools/perf/util/include/linux/hash.h
new file mode 100644
index 0000000..201f573
--- /dev/null
+++ b/tools/perf/util/include/linux/hash.h
@@ -0,0 +1,5 @@
+#include "../../../../include/linux/hash.h"
+
+#ifndef PERF_HASH_H
+#define PERF_HASH_H
+#endif
