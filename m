Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZIVWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZIVWSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 18:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZIVWSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 18:18:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:64399 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZIVWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 18:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CiBKKrkTAicwaGI8+98UNNNKFCShggF0HctilGkwuWrpPHxSoTYU61VYsXXPeVZRho
         rKJQHhURfscCwYd3JFaml0CXeFUVYV2xzyktnMURidwN97CYAxr9HXYF+P78XL92EY+L
         m9hfpW0M5SRyi8XIAf8eYUZKD7up/5W3j/Djk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Hong <lihong.hi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] tracing: Fix a comment and a trivial format issue in tracepoint.h
Date: Wed, 23 Sep 2009 00:18:29 +0200
Message-Id: <1253657910-2536-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253657910-2536-1-git-send-email-fweisbec@gmail.com>
References: <1253657910-2536-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

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
 
-- 
1.6.2.3

