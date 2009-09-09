Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZIIQsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZIIQsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZIIQsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:48:51 -0400
Received: from mail.perches.com ([173.55.12.10]:1065 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZIIQsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:48:50 -0400
Subject: [PATCH] ftrace.h: TP_fast_assign - use do {} while (0);
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Sep 2009 09:48:53 -0700
Message-Id: <1252514933.28130.45.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps this is a more kernel style standard way to allow
local variables in TP_fast_assign.

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=a9c1c3abe1160a5632e48c929b02b740556bf423

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f64fbaa..4c99bdc 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -142,7 +142,7 @@
 #define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
 
 #undef TP_fast_assign
-#define TP_fast_assign(args...) args
+#define TP_fast_assign(args...) do { args } while (0);
 
 #undef TP_perf_assign
 #define TP_perf_assign(args...)


