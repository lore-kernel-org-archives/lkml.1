Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZILHxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZILHxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZILHxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:53:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:33477 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZILHx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:53:28 -0400
Date: Sat, 12 Sep 2009 07:53:07 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AA8579B.4020706@cn.fujitsu.com>
References: <4AA8579B.4020706@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: remove stats from struct tracer
Message-ID: <tip-a5921c6c37d51ee2079ca3c69ea6f7b7384f5d87@git.kernel.org>
Git-Commit-ID: a5921c6c37d51ee2079ca3c69ea6f7b7384f5d87
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:53:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5921c6c37d51ee2079ca3c69ea6f7b7384f5d87
Gitweb:     http://git.kernel.org/tip/a5921c6c37d51ee2079ca3c69ea6f7b7384f5d87
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 10 Sep 2009 09:34:19 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Sep 2009 23:54:09 -0400

tracing: remove stats from struct tracer

Remove unused field @stats from struct tracer.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AA8579B.4020706@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 86a0523..2163d18 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -382,7 +382,6 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags	*flags;
-	struct tracer_stat	*stats;
 };
 
 
