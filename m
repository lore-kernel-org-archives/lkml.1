Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397Ab0A3LoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0A3LoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776Ab0A3Lnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:43:43 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52229 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0A3Lnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:43:42 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 02/11] perf: Add util/include/linuxhash.h to include hash.h of kernel
Date: Sat, 30 Jan 2010 20:43:24 +0900
Message-Id: <1264851813-8413-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/hash.h, hash header of kernel, is also useful for perf.

util/include/linuxhash.h includes linux/hash.h, so we can use
hash facilities (e.g. hash_long()) in perf now.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile                  |    1 +
 tools/perf/util/include/linux/hash.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/include/linux/hash.h

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
-- 
1.6.5.2

