Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbZEORqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbZEORqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZEORq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:46:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:42785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbZEORqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:46:25 -0400
Date: Fri, 15 May 2009 17:45:45 GMT
From: tip-bot for GeunSik Lim <leemgs1@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       williams@redhat.com, geunsik.lim@samsung.com, leemgs1@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, geunsik.lim@samsung.com, williams@redhat.com,
       leemgs1@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1242289418.31161.45.camel@centos51>
References: <1242289418.31161.45.camel@centos51>
Subject: [tip:tracing/urgent] tracing: Append prompt in /debug/tracing/README file
Message-ID: <tip-88fc86c283d9c3854e67e4155808027bc2519eb6@git.kernel.org>
Git-Commit-ID: 88fc86c283d9c3854e67e4155808027bc2519eb6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 17:45:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88fc86c283d9c3854e67e4155808027bc2519eb6
Gitweb:     http://git.kernel.org/tip/88fc86c283d9c3854e67e4155808027bc2519eb6
Author:     GeunSik Lim <leemgs1@gmail.com>
AuthorDate: Thu, 14 May 2009 17:23:38 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 19:43:22 +0200

tracing: Append prompt in /debug/tracing/README file

append prompt in /debug/tracing/README file.

This is trivial issue. Fix typo Mini Howto file(README) for ftrace.

[ Impact: cleanup ]

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: williams <williams@redhat.com>
LKML-Reference: <1242289418.31161.45.camel@centos51>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a884c09..cda81ec 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2380,7 +2380,7 @@ static const char readme_msg[] =
 	"# echo print-parent > /debug/tracing/trace_options\n"
 	"# echo 1 > /debug/tracing/tracing_enabled\n"
 	"# cat /debug/tracing/trace > /tmp/trace.txt\n"
-	"echo 0 > /debug/tracing/tracing_enabled\n"
+	"# echo 0 > /debug/tracing/tracing_enabled\n"
 ;
 
 static ssize_t
