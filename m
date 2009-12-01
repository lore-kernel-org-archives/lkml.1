Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbZLAQor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbZLAQor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZLAQoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:44:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:42349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbZLAQop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:44:45 -0500
Date: Tue, 1 Dec 2009 16:43:59 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B14D2A6.6060803@cn.fujitsu.com>
References: <4B14D2A6.6060803@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_syscalls: Remove unused syscall_name_to_nr()
Message-ID: <tip-7be077f56370cd52c48c08272b0867132f87bc48@git.kernel.org>
Git-Commit-ID: 7be077f56370cd52c48c08272b0867132f87bc48
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7be077f56370cd52c48c08272b0867132f87bc48
Gitweb:     http://git.kernel.org/tip/7be077f56370cd52c48c08272b0867132f87bc48
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 16:24:06 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 17:33:31 +0100

trace_syscalls: Remove unused syscall_name_to_nr()

After duplications are removed, syscall_name_to_nr() is unused.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B14D2A6.6060803@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_syscalls.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 1e85b6c..57501d9 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -51,22 +51,6 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
-static int syscall_name_to_nr(const char *name)
-{
-	int i;
-
-	if (!syscalls_metadata)
-		return -1;
-
-	for (i = 0; i < NR_syscalls; i++) {
-		if (syscalls_metadata[i]) {
-			if (!strcmp(syscalls_metadata[i]->name, name))
-				return i;
-		}
-	}
-	return -1;
-}
-
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
 {
