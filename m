Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYJFXMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYJFXMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJFXLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:11:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYJFXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:11:50 -0400
Message-Id: <20081006231149.438702200@goodmis.org>
References: <20081006230610.024517480@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Oct 2008 19:06:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: rename the ftrace tracer to function
Content-Disposition: inline; filename=ftrace-rename-function-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid further confusion between the ftrace infrastructure and the
function tracer. This patch renames the "ftrace" function tracer
to "function".

Now in available_tracers, instead of "ftrace" there will be "function".

This makes more sense, since people will not know exactly what the
"ftrace" tracer does.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace_functions.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_functions.c	2008-10-06 18:50:38.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_functions.c	2008-10-06 18:51:09.000000000 -0400
@@ -64,7 +64,7 @@ static void function_trace_ctrl_update(s
 
 static struct tracer function_trace __read_mostly =
 {
-	.name	     = "ftrace",
+	.name	     = "function",
 	.init	     = function_trace_init,
 	.reset	     = function_trace_reset,
 	.ctrl_update = function_trace_ctrl_update,

-- 
