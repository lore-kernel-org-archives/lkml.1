Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935729Ab0BZJ24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:28:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:39771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935689Ab0BZJ2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:28:51 -0500
Date: Fri, 26 Feb 2010 09:28:36 GMT
From: tip-bot for Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, wenji.huang@oracle.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, wenji.huang@oracle.com
In-Reply-To: <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix typo of info text in trace_kprobe.c
Message-ID: <tip-a5efd925115cbc1f90195dca9a25f7b8daa10c37@git.kernel.org>
Git-Commit-ID: a5efd925115cbc1f90195dca9a25f7b8daa10c37
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:28:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5efd925115cbc1f90195dca9a25f7b8daa10c37
Gitweb:     http://git.kernel.org/tip/a5efd925115cbc1f90195dca9a25f7b8daa10c37
Author:     Wenji Huang <wenji.huang@oracle.com>
AuthorDate: Wed, 24 Feb 2010 15:40:23 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 25 Feb 2010 10:36:29 -0500

tracing: Fix typo of info text in trace_kprobe.c

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
LKML-Reference: <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c990299..8d4bd16 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -651,12 +651,12 @@ static int create_trace_probe(int argc, char **argv)
 			event = strchr(group, '/') + 1;
 			event[-1] = '\0';
 			if (strlen(group) == 0) {
-				pr_info("Group name is not specifiled\n");
+				pr_info("Group name is not specified\n");
 				return -EINVAL;
 			}
 		}
 		if (strlen(event) == 0) {
-			pr_info("Event name is not specifiled\n");
+			pr_info("Event name is not specified\n");
 			return -EINVAL;
 		}
 	}
