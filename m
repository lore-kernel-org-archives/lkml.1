Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbZIWJEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbZIWJEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZIWJEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:04:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZIWJEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:04:34 -0400
Date: Wed, 23 Sep 2009 09:04:07 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <3a3680030909220300h7cf18849q4d4702b9d4feaa67@mail.gmail.com>
References: <3a3680030909220300h7cf18849q4d4702b9d4feaa67@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix a comment and a trivial format issue in tracepoint.h
Message-ID: <tip-8cd09a5984c08dafade74c9c1ab4311af2bf2d24@git.kernel.org>
Git-Commit-ID: 8cd09a5984c08dafade74c9c1ab4311af2bf2d24
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 09:04:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cd09a5984c08dafade74c9c1ab4311af2bf2d24
Gitweb:     http://git.kernel.org/tip/8cd09a5984c08dafade74c9c1ab4311af2bf2d24
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Tue, 22 Sep 2009 18:00:44 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 22 Sep 2009 23:14:58 +0200

tracing: Fix a comment and a trivial format issue in tracepoint.h

Fix the tracepoint documentation path in tracepoints headers and
a misaligned tabulation.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
LKML-Reference: <3a3680030909220300h7cf18849q4d4702b9d4feaa67@mail.gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 include/linux/tracepoint.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 63a3f7a..2aac8a8 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -4,7 +4,7 @@
 /*
  * Kernel Tracepoint API.
  *
- * See Documentation/tracepoint.txt.
+ * See Documentation/trace/tracepoints.txt.
  *
  * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -36,7 +36,7 @@ struct tracepoint {
 #ifndef DECLARE_TRACE
 
 #define TP_PROTO(args...)	args
-#define TP_ARGS(args...)		args
+#define TP_ARGS(args...)	args
 
 #ifdef CONFIG_TRACEPOINTS
 
