Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZLXOn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZLXOn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 09:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZLXOn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 09:43:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:54104 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZLXOn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 09:43:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf tools: Add missing header files to LIB_H Makefile variable
Date: Thu, 24 Dec 2009 12:43:45 -0200
Message-Id: <1261665825-23316-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that changes in them trigger rebuilds, like when we're doing bisects.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4390d22..652a470 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -343,13 +343,18 @@ LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bitops.h
+LIB_H += util/include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
 LIB_H += perf.h
+LIB_H += util/cache.h
+LIB_H += util/callchain.h
+LIB_H += util/debug.h
 LIB_H += util/debugfs.h
 LIB_H += util/event.h
+LIB_H += util/exec_cmd.h
 LIB_H += util/types.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
@@ -362,6 +367,7 @@ LIB_H += util/session.h
 LIB_H += util/strbuf.h
 LIB_H += util/string.h
 LIB_H += util/strlist.h
+LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
@@ -370,6 +376,8 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
+LIB_H += util/trace-event.h
+LIB_H += util/trace-event-perl.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 
-- 
1.6.5.2

