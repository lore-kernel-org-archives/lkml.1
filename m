Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZCWPT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZCWPT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758335AbZCWPTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:19:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:48130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbZCWPT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:19:29 -0400
Date: Mon, 23 Mar 2009 15:18:46 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
References: <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace] tracing: add missing 'extern' keywords to trace_output.h
Message-ID: <tip-2e9a5eb48c155faaed8483688f9d25ddeaccaecf@git.kernel.org>
Git-Commit-ID: 2e9a5eb48c155faaed8483688f9d25ddeaccaecf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:18:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e9a5eb48c155faaed8483688f9d25ddeaccaecf
Gitweb:     http://git.kernel.org/tip/2e9a5eb48c155faaed8483688f9d25ddeaccaecf
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:06:55 +0100

tracing: add missing 'extern' keywords to trace_output.h

Impact: cleanup

Many declarations within trace_output.h are missing the 'extern' keyword
in an inconsistent manner. This adds 'extern' where it should be.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_output.h |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 0ae20b8..46fb961 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -29,25 +29,26 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
 		unsigned long sym_flags);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
-int trace_seq_puts(struct trace_seq *s, const char *str);
-int trace_seq_putc(struct trace_seq *s, unsigned char c);
-int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len);
-int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len);
-void *trace_seq_reserve(struct trace_seq *s, size_t len);
-int trace_seq_path(struct trace_seq *s, struct path *path);
-int seq_print_userip_objs(const struct userstack_entry *entry,
-			  struct trace_seq *s, unsigned long sym_flags);
-int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
-		      unsigned long ip, unsigned long sym_flags);
+extern int trace_seq_puts(struct trace_seq *s, const char *str);
+extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
+extern int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len);
+extern int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len);
+extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
+extern int trace_seq_path(struct trace_seq *s, struct path *path);
+extern int seq_print_userip_objs(const struct userstack_entry *entry,
+				 struct trace_seq *s, unsigned long sym_flags);
+extern int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
+			     unsigned long ip, unsigned long sym_flags);
 
-int trace_print_context(struct trace_iterator *iter);
-int trace_print_lat_context(struct trace_iterator *iter);
+extern int trace_print_context(struct trace_iterator *iter);
+extern int trace_print_lat_context(struct trace_iterator *iter);
 
-struct trace_event *ftrace_find_event(int type);
-int register_ftrace_event(struct trace_event *event);
-int unregister_ftrace_event(struct trace_event *event);
+extern struct trace_event *ftrace_find_event(int type);
+extern int register_ftrace_event(struct trace_event *event);
+extern int unregister_ftrace_event(struct trace_event *event);
 
-enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags);
+extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
+					 int flags);
 
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
