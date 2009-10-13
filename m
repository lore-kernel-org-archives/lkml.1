Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbZJMHjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbZJMHjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbZJMHjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:39:45 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40030 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbZJMHjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W3oBGRKAwuCHy0G8CNxPSiGuFiVQD3mrZtngtYXP3OPh4Oa6voSfnAYWj2tx2DbXgL
         KjKMrswLqaLoGQwCEVE/R/s55BDbQVOtBzeqt4q/L9+KE44m2aoSKAEY/Cbd9MSjp49Z
         2J9qwdZdjo6BRCLQbND+0hnJe/iIRH9rihKEk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/3] tracing: Rename set_ftrace to set_bootup_ftrace
Date: Tue, 13 Oct 2009 09:38:59 +0200
Message-Id: <1255419540-5481-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do this rename because set_ftrace is too much generic and not enough
self-explainable as a name.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4506826..866daf8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -129,7 +129,7 @@ static int tracing_set_tracer(const char *buf);
 static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
 static char *default_bootup_tracer;
 
-static int __init set_ftrace(char *str)
+static int __init set_bootup_ftrace(char *str)
 {
 	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
@@ -137,7 +137,7 @@ static int __init set_ftrace(char *str)
 	ring_buffer_expanded = 1;
 	return 1;
 }
-__setup("ftrace=", set_ftrace);
+__setup("ftrace=", set_bootup_ftrace);
 
 static int __init set_ftrace_dump_on_oops(char *str)
 {
-- 
1.6.2.3

