Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZJUOhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZJUOhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZJUOhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZJUOg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:36:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] tracing: comment typo and documentation example fix
Date: Wed, 21 Oct 2009 16:36:40 +0200
Message-Id: <1256135801-1849-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
index e43c928..d33e5ca 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2684,7 +2684,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 EXPORT_SYMBOL_GPL(ring_buffer_entries);
 
 /**
- * ring_buffer_overrun_cpu - get the number of overruns in buffer
+ * ring_buffer_overruns - get the number of overruns in buffer
  * @buffer: The ring buffer
  *
  * Returns the total number of overruns in the ring buffer
-- 
1.6.2.5

