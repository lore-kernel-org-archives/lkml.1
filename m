Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114Ab0AaIcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0AaIcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607Ab0AaIcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:32:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:51290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab0AaIcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:32:17 -0500
Date: Sun, 31 Jan 2010 08:31:27 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264851813-8413-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add util/include/linuxhash.h to include hash.h of kernel
Message-ID: <tip-18e97e06b5fb2d7f6cf272ca07d26d8247db8723@git.kernel.org>
Git-Commit-ID: 18e97e06b5fb2d7f6cf272ca07d26d8247db8723
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 08:31:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18e97e06b5fb2d7f6cf272ca07d26d8247db8723
Gitweb:     http://git.kernel.org/tip/18e97e06b5fb2d7f6cf272ca07d26d8247db8723
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Sat, 30 Jan 2010 20:43:24 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 Jan 2010 08:27:53 +0100

perf: Add util/include/linuxhash.h to include hash.h of kernel

linux/hash.h, hash header of kernel, is also useful for perf.

util/include/linuxhash.h includes linux/hash.h, so we can use
hash facilities (e.g. hash_long()) in perf now.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1264851813-8413-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile                  |    1 +
 tools/perf/util/include/linux/hash.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9b173e6..b2bce1f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -333,6 +333,7 @@ LIB_FILE=libperf.a
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
