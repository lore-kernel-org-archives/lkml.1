Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZDMDyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZDMDyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZDMDyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:54:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZDMDya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:54:30 -0400
Message-ID: <49E2B763.8060706@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 11:54:11 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tracing, boottrace: Move include/trace/boot.h to include/linux/boottrace.h
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: refactor code, no functionality changed

Files in include/trace/ should be definition of tracepoints, and header
file for boot trace should put to include/linux/.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/{trace/boot.h => linux/boottrace.h} |    0 
 init/main.c                                 |    2 +-
 kernel/trace/trace.h                        |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename include/{trace/boot.h => linux/boottrace.h} (100%)

diff --git a/include/trace/boot.h b/include/linux/boottrace.h
similarity index 100%
rename from include/trace/boot.h
rename to include/linux/boottrace.h
diff --git a/init/main.c b/init/main.c
index 694a563..d7d4741 100644
--- a/init/main.c
+++ b/init/main.c
@@ -66,7 +66,7 @@
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/kmemtrace.h>
-#include <trace/boot.h>
+#include <linux/boottrace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ce6bdc4..5b654ce 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -8,7 +8,7 @@
 #include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
-#include <trace/boot.h>
+#include <linux/boottrace.h>
 #include <linux/kmemtrace.h>
 #include <trace/power.h>
 
-- 
1.5.5.3


