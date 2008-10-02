Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYJBPr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYJBPr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJBPrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:47:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57343 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYJBPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:47:17 -0400
Date: Thu, 2 Oct 2008 17:47:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing/fastboot: build fix
Message-ID: <20081002154711.GA20885@elte.hu>
References: <48E4AFCD.9080004@gmail.com> <20081002120231.GB14322@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002120231.GB14322@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 7d14307eeaa710427436c09c6f77dde1974621cf Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 2 Oct 2008 17:45:47 +0200
Subject: [PATCH] tracing/fastboot: build fix

fix:

 In file included from kernel/sysctl.c:52:
 include/linux/ftrace.h:217: error: 'KSYM_NAME_LEN' undeclared here (not in a function)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e672e51..deded11 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -1,14 +1,14 @@
 #ifndef _LINUX_FTRACE_H
 #define _LINUX_FTRACE_H
 
-#ifdef CONFIG_FTRACE
-
 #include <linux/linkage.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 
+#ifdef CONFIG_FTRACE
+
 extern int ftrace_enabled;
 extern int
 ftrace_enable_sysctl(struct ctl_table *table, int write,
