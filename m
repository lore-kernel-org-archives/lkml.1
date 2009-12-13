Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbZLMHhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbZLMHhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 02:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZLMHhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 02:37:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:48659 "HELO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751258AbZLMHht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 02:37:49 -0500
Date: Sun, 13 Dec 2009 07:37:15 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, joe@perches.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260651974.2637.4.camel@Joe-Laptop.home>
References: <1260651974.2637.4.camel@Joe-Laptop.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ftrace.h: Use common pr_info fmt string
Message-ID: <tip-4819568f23a8bef0ca99b740ca60fe2450ab0aac@git.kernel.org>
Git-Commit-ID: 4819568f23a8bef0ca99b740ca60fe2450ab0aac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4819568f23a8bef0ca99b740ca60fe2450ab0aac
Gitweb:     http://git.kernel.org/tip/4819568f23a8bef0ca99b740ca60fe2450ab0aac
Author:     Joe Perches <joe@perches.com>
AuthorDate: Sat, 12 Dec 2009 13:06:13 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Dec 2009 08:14:45 +0100

ftrace.h: Use common pr_info fmt string

Reduces fmt string space a bit.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1260651974.2637.4.camel@Joe-Laptop.home>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index d1b3de9..c4eca38 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -733,7 +733,7 @@ static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
 	ret = register_trace_##call(ftrace_raw_event_##call);		\
 	if (ret)							\
 		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
+			"probe to %s\n", #call);			\
 	return ret;							\
 }									\
 									\
