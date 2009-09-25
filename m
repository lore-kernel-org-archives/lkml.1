Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZIYTOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZIYTOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZIYTOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZIYTOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:14:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC PATCH tracing/kprobes 3/5] tracing/kprobes: Rename fixed field
	name
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 25 Sep 2009 12:15:32 -0700
Message-ID: <20090925191531.12939.91364.stgit@omoto>
In-Reply-To: <20090925191424.12939.91503.stgit@omoto>
References: <20090925191424.12939.91503.stgit@omoto>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename probe-common fixed field name to the name harder conflictable,
because current 'ip', 'func', and other probe field names are easy to
conflict with user-specified variable names.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---

 kernel/trace/trace_kprobe.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c09411f..802effe 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -39,10 +39,10 @@
 #define KPROBE_EVENT_SYSTEM "kprobes"
 
 /* Reserved field names */
-#define FIELD_STRING_IP "ip"
-#define FIELD_STRING_NARGS "nargs"
-#define FIELD_STRING_RETIP "ret_ip"
-#define FIELD_STRING_FUNC "func"
+#define FIELD_STRING_IP "__probe_ip"
+#define FIELD_STRING_NARGS "__probe_nargs"
+#define FIELD_STRING_RETIP "__probe_ret_ip"
+#define FIELD_STRING_FUNC "__probe_func"
 
 const char *reserved_field_names[] = {
 	"common_type",


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
