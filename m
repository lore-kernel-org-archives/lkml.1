Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbZJWXgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbZJWXgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZJWXgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:36:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51475 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZJWXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:36:42 -0400
Message-Id: <20091023233646.871719877@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Oct 2009 19:36:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] [PATCH 3/4] tracing: comment typo and documentation example fix
References: <20091023233615.661789185@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-comment-typo-and-documentation-example-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Trivial patch to fix a documentation example and fixes a comment.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1256135801-1849-4-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |    2 ++
 kernel/trace/ring_buffer.c     |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 957b22f..8179692 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1231,6 +1231,7 @@ something like this simple program:
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <string.h>
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
@@ -1265,6 +1266,7 @@ const char *find_debugfs(void)
                return NULL;
        }
 
+       strcat(debugfs, "/tracing/");
        debugfs_found = 1;
 
        return debugfs;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d4ff019..217f699 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2681,7 +2681,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 EXPORT_SYMBOL_GPL(ring_buffer_entries);
 
 /**
- * ring_buffer_overrun_cpu - get the number of overruns in buffer
+ * ring_buffer_overruns - get the number of overruns in buffer
  * @buffer: The ring buffer
  *
  * Returns the total number of overruns in the ring buffer
-- 
1.6.3.3


