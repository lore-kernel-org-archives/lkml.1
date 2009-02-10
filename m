Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZBJIzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZBJIzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZBJIym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:54:42 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:40850 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZBJIyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:54:41 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 3/3] trace: fix typos in comment.
Date: Tue, 10 Feb 2009 01:03:18 -0500
Message-Id: <1234245798-14546-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.499140CB.003A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clean up.

Fix some typos in comment and re-send it based previous code sent to steven
in better submission way.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
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
index 53ba3a6..22ccadc 100644
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
index 5b1e9a9..7072909 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1943,7 +1943,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
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
1.5.6

