Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0BXHls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:41:48 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:21660 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab0BXHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:40:55 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH -tip 1/5] tracing: fix typo in prof_sysexit_enable()
Date: Wed, 24 Feb 2010 15:40:22 +0800
Message-Id: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B84D803.00E3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_syscalls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 6cce6a8..9d45122 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -552,7 +552,7 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 		ret = register_trace_sys_exit(prof_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+				"syscall exit trace point");
 	} else {
 		set_bit(num, enabled_prof_exit_syscalls);
 		sys_prof_refcount_exit++;
-- 
1.5.6

