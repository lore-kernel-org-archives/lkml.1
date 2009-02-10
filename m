Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZBJRib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZBJRib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZBJRgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZBJRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:20 -0500
Message-Id: <20090210173619.329681961@goodmis.org>
References: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/7] tracing: fix typos in comments
Content-Disposition: inline; filename=0007-tracing-fix-typos-in-comments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Impact: clean up.

Fix typos in the comments.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h      |    2 +-
 kernel/trace/ring_buffer.c       |    8 ++++----
 kernel/trace/trace.c             |    2 +-
 kernel/trace/trace_hw_branches.c |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 3c103d6..8e6646a 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -8,7 +8,7 @@ struct ring_buffer;
 struct ring_buffer_iter;
 
 /*
- * Don't reference this struct directly, use functions below.
+ * Don't refer to this struct directly, use functions below.
  */
 struct ring_buffer_event {
 	u32		type:2, len:3, time_delta:27;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 10d202e..fa64e1f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(tracing_off);
  * tracing_off_permanent - permanently disable ring buffers
  *
  * This function, once called, will disable all ring buffers
- * permanenty.
+ * permanently.
  */
 void tracing_off_permanent(void)
 {
@@ -210,7 +210,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
-	local_t		 commit;	/* write commited index */
+	local_t		 commit;	/* write committed index */
 	unsigned char	 data[];	/* data of buffer page */
 };
 
@@ -260,7 +260,7 @@ struct ring_buffer_per_cpu {
 	struct list_head		pages;
 	struct buffer_page		*head_page;	/* read from head */
 	struct buffer_page		*tail_page;	/* write to tail */
-	struct buffer_page		*commit_page;	/* commited pages */
+	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
 	unsigned long			overrun;
 	unsigned long			entries;
@@ -303,7 +303,7 @@ struct ring_buffer_iter {
  * check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
  *
- * As a safty measure we check to make sure the data pages have not
+ * As a safety measure we check to make sure the data pages have not
  * been corrupted.
  */
 static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d898212..d7c175a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1963,7 +1963,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	struct tracer_opt *trace_opts = current_trace->flags->opts;
 
 
-	/* calulate max size */
+	/* calculate max size */
 	for (i = 0; trace_options[i]; i++) {
 		len += strlen(trace_options[i]);
 		len += 3; /* "no" and space */
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index e3e7db6..0794dd3 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -75,7 +75,7 @@ static void bts_trace_start(struct trace_array *tr)
 }
 
 /*
- * Start tracing on the current cpu.
+ * Stop tracing on the current cpu.
  * The argument is ignored.
  *
  * pre: bts_tracer_mutex must be locked.
-- 
1.5.6.5

-- 
