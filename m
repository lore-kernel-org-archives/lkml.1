Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720Ab0BZJ2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:28:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:39770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935688Ab0BZJ2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:28:51 -0500
Date: Fri, 26 Feb 2010 09:28:21 GMT
From: tip-bot for Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, wenji.huang@oracle.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, wenji.huang@oracle.com
In-Reply-To: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix typo in prof_sysexit_enable()
Message-ID: <tip-6574658b3bc7c408581629de5efb809f125cce8c@git.kernel.org>
Git-Commit-ID: 6574658b3bc7c408581629de5efb809f125cce8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:28:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6574658b3bc7c408581629de5efb809f125cce8c
Gitweb:     http://git.kernel.org/tip/6574658b3bc7c408581629de5efb809f125cce8c
Author:     Wenji Huang <wenji.huang@oracle.com>
AuthorDate: Wed, 24 Feb 2010 15:40:22 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 25 Feb 2010 10:35:55 -0500

tracing: Fix typo in prof_sysexit_enable()

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
LKML-Reference: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 49cea70..8cdda95 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -603,7 +603,7 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 		ret = register_trace_sys_exit(prof_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+				"syscall exit trace point");
 	} else {
 		set_bit(num, enabled_prof_exit_syscalls);
 		sys_prof_refcount_exit++;
