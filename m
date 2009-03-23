Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZCWNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZCWNNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZCWNMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:12:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:50642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbZCWNMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BHRAQEiCbCQJqBoGEDy0oKmnIcKBlTIpit8kvcQqOHiGmpodXKIQcCU/3Yfwdo2wPN
         MWOD6kNTYtdeFXdgvBW/puJ7Y3kLeHmlqC/zA7VeRE9P/6409aUApQZ0Ca4LDFS3UU+h
         bah6Fc/3zKJ8lQmzrgZCgEoRwXwVnETSMW61k=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] tracing: add missing 'extern' keywords to trace_output.h
Date: Mon, 23 Mar 2009 15:12:23 +0200
Message-Id: <8437e9b2ad54db68fa3c3dd89205bc7b50f203b5.1237813499.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
 <75eba730cfee8e771090b60c4b252bd8d3ffcb18.1237813499.git.eduard.munteanu@linux360.ro>
 <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
In-Reply-To: <cover.1237813499.git.eduard.munteanu@linux360.ro>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many declarations within trace_output.h are missing the 'extern' keyword
in an inconsistent manner. This adds 'extern' where it should be.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/trace_output.h |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index cbc0ec8..6997c87 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -23,25 +23,26 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
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
-
-int trace_print_context(struct trace_iterator *iter);
-int trace_print_lat_context(struct trace_iterator *iter);
-
-struct trace_event *ftrace_find_event(int type);
-int register_ftrace_event(struct trace_event *event);
-int unregister_ftrace_event(struct trace_event *event);
-
-enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags);
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
+
+extern int trace_print_context(struct trace_iterator *iter);
+extern int trace_print_lat_context(struct trace_iterator *iter);
+
+extern struct trace_event *ftrace_find_event(int type);
+extern int register_ftrace_event(struct trace_event *event);
+extern int unregister_ftrace_event(struct trace_event *event);
+
+extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
+					 int flags);
 
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-- 
1.6.0.6

