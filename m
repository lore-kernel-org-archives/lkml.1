Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZDGNO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZDGNO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZDGNNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:13:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:59381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384AbZDGNNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:13:35 -0400
Date: Tue, 7 Apr 2009 13:12:49 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1238160130-7437-1-git-send-email-fweisbec@gmail.com>
References: <1238160130-7437-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/urgent] tracing/ftrace: fix missing include string.h
Message-ID: <tip-5f0c6c03c5fee91c02c696bc9bf4c0d41392abe7@git.kernel.org>
Git-Commit-ID: 5f0c6c03c5fee91c02c696bc9bf4c0d41392abe7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:12:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f0c6c03c5fee91c02c696bc9bf4c0d41392abe7
Gitweb:     http://git.kernel.org/tip/5f0c6c03c5fee91c02c696bc9bf4c0d41392abe7
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 27 Mar 2009 14:22:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:00:18 +0200

tracing/ftrace: fix missing include string.h

Building a kernel with tracing can raise the following warning on
tip/master:

kernel/trace/trace.c:1249: error: implicit declaration of function 'vbin_printf'

We are missing an include to string.h

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1238160130-7437-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 457dd8c..2230b46 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/splice.h>
 #include <linux/kdebug.h>
+#include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
