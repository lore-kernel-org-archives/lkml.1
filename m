Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZITRko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZITRko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZITRkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:40:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:49503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbZITRkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:40:41 -0400
Date: Sun, 20 Sep 2009 17:40:01 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1253442878.7542.3.camel@laptop>
References: <1253442878.7542.3.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Export trace_profile_buf symbols
Message-ID: <tip-05bafda856092de0705de239c846777bddb94974@git.kernel.org>
Git-Commit-ID: 05bafda856092de0705de239c846777bddb94974
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 17:40:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05bafda856092de0705de239c846777bddb94974
Gitweb:     http://git.kernel.org/tip/05bafda856092de0705de239c846777bddb94974
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 20 Sep 2009 12:34:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 19:15:57 +0200

tracing: Export trace_profile_buf symbols

ERROR: "trace_profile_buf_nmi" [fs/jbd2/jbd2.ko] undefined!
ERROR: "trace_profile_buf" [fs/jbd2/jbd2.ko] undefined!
ERROR: "trace_profile_buf_nmi" [fs/ext4/ext4.ko] undefined!
ERROR: "trace_profile_buf" [fs/ext4/ext4.ko] undefined!
ERROR: "trace_profile_buf_nmi" [arch/x86/kvm/kvm.ko] undefined!
ERROR: "trace_profile_buf" [arch/x86/kvm/kvm.ko] undefined!

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1253442878.7542.3.camel@laptop>
[ fixed whitespace noise and checkpatch complaint ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_event_profile.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 3aaa77c..dd44b87 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -15,7 +15,10 @@
 typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
 
 char		*trace_profile_buf;
-char 		*trace_profile_buf_nmi;
+EXPORT_SYMBOL_GPL(trace_profile_buf);
+
+char		*trace_profile_buf_nmi;
+EXPORT_SYMBOL_GPL(trace_profile_buf_nmi);
 
 /* Count the events in use (per event id, not per instance) */
 static int	total_profile_count;
