Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642Ab0AZWR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0AZWR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480Ab0AZWRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:17:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0AZWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:17:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=-UEbvbkI5EgA:10 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=_e04m_mCUhX7dqaRSE4A:9 a=F9FNkLFbGmwRlkXGT2veo8_ECmkA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100126221713.186959154@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 17:09:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>
Subject: [PATCH 4/5] tracing/documentation: Fix a typo in ftrace.txt
References: <20100126220923.534282809@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-documentation-Fix-a-typo-in-ftrace.txt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Hongyang <yanghy@cn.fujitsu.com>

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
-- 
1.6.5


