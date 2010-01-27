Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239Ab0A0NPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0A0NPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104Ab0A0NPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:15:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:37670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab0A0NPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:15:37 -0500
Date: Wed, 27 Jan 2010 13:15:08 GMT
From: tip-bot for Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, yanghy@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yanghy@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4B5D0BA8.20106@cn.fujitsu.com>
References: <4B5D0BA8.20106@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/documentation: Fix a typo in ftrace.txt
Message-ID: <tip-6993b1bb1e62367f500789835a1f747e12259f07@git.kernel.org>
Git-Commit-ID: 6993b1bb1e62367f500789835a1f747e12259f07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:15:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6993b1bb1e62367f500789835a1f747e12259f07
Gitweb:     http://git.kernel.org/tip/6993b1bb1e62367f500789835a1f747e12259f07
Author:     Yang Hongyang <yanghy@cn.fujitsu.com>
AuthorDate: Mon, 25 Jan 2010 11:10:32 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 26 Jan 2010 16:59:33 -0500

tracing/documentation: Fix a typo in ftrace.txt

'ftrace' is no longer the name of the function tracer, to activate
the function trace 'echo function > current_tracer' is to be used instead
of 'echo ftrace > current_tracer'. Update the documentation to reflect
the current implementation.

Signed-off-by: Yang Hongyang <yanghy@cn.fujitsu.com>
LKML-Reference: <4B5D0BA8.20106@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 8179692..bab3040 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1625,7 +1625,7 @@ If I am only interested in sys_nanosleep and hrtimer_interrupt:
 
  # echo sys_nanosleep hrtimer_interrupt \
 		> set_ftrace_filter
- # echo ftrace > current_tracer
+ # echo function > current_tracer
  # echo 1 > tracing_enabled
  # usleep 1
  # echo 0 > tracing_enabled
