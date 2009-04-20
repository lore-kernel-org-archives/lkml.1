Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZDTPpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZDTPpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZDTPoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:44:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbZDTPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:44:04 -0400
Message-Id: <20090420154400.775016387@goodmis.org>
References: <20090420154325.698204138@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 11:43:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] tracing: rename EVENT_TRACER config to ENABLE_EVENT_TRACING
Content-Disposition: inline; filename=0003-tracing-rename-EVENT_TRACER-config-to-ENABLE_EVENT_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently we have two configs: EVENT_TRACING and EVENT_TRACER.
All tracers enable EVENT_TRACING. The EVENT_TRACER is only a
convenience to enable the EVENT_TRACING when no other tracers
are enabled.

The names EVENT_TRACER and EVENT_TRACING are too similar and confusing.
This patch renames EVENT_TRACER to ENABLE_EVENT_TRACING to be more
appropriate to what it actually does, as well as add a comment in
the help menu to explain the option's purpose.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 3fa36d2..450d3c2 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -183,7 +183,7 @@ config CONTEXT_SWITCH_TRACER
 	  This tracer gets called from the context switch and records
 	  all switching of tasks.
 
-config EVENT_TRACER
+config ENABLE_EVENT_TRACING
 	bool "Trace various events in the kernel"
 	select TRACING
 	help
@@ -191,6 +191,10 @@ config EVENT_TRACER
 	  allowing the user to pick and choose which trace point they
 	  want to trace.
 
+	  Note, all tracers enable event tracing. This option is
+	  only a convenience to enable event tracing when no other
+	  tracers are selected.
+
 config FTRACE_SYSCALLS
 	bool "Trace syscalls"
 	depends on HAVE_FTRACE_SYSCALLS
-- 
1.6.2.1

-- 
