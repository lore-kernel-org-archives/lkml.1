Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0BUH7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 02:59:10 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:43257 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0BUH7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 02:59:08 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH -tip] tracing: fix typo in prof_sysexit_enable()
Date: Sun, 21 Feb 2010 15:51:31 +0800
Message-Id: <1266738691-8503-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B80E7C6.0087:SCFMA4539814,ss=1,fgs=0
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

