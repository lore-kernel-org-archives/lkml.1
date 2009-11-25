Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbZKYIcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbZKYIcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbZKYIcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:32:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:48047 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZKYIcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:32:42 -0500
Date: Wed, 25 Nov 2009 08:31:44 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259133299-23594-3-git-send-email-tzanussi@gmail.com>
References: <1259133299-23594-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace/syscalls: Change ret param in struct syscall_trace_exit to long
Message-ID: <tip-99df5a6a215f026e62287083de2b44b22edd3623@git.kernel.org>
Git-Commit-ID: 99df5a6a215f026e62287083de2b44b22edd3623
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99df5a6a215f026e62287083de2b44b22edd3623
Gitweb:     http://git.kernel.org/tip/99df5a6a215f026e62287083de2b44b22edd3623
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 25 Nov 2009 01:14:59 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Nov 2009 09:06:10 +0100

trace/syscalls: Change ret param in struct syscall_trace_exit to long

Commit ee949a86b3aef15845ea677aa60231008de62672 ("tracing/syscalls:
Use long for syscall ret format and field definitions") changed the
syscall exit return type to long, but forgot to change it in the
struct.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1259133299-23594-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4da6ede..1d7f483 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -100,7 +100,7 @@ struct syscall_trace_enter {
 struct syscall_trace_exit {
 	struct trace_entry	ent;
 	int			nr;
-	unsigned long		ret;
+	long			ret;
 };
 
 struct kprobe_trace_entry {
