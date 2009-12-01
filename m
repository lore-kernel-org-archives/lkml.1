Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZLAIYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZLAIYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZLAIYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:24:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58643 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbZLAIYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:24:40 -0500
Message-ID: <4B14D2A6.6060803@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 16:24:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] trace_syscalls: remove unused syscall_name_to_nr()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After duplications are removed, syscall_name_to_nr() is unused.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
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


