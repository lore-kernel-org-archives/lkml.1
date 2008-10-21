Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbYJUObj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbYJUObj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYJUObb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:31:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:43735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYJUObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:31:31 -0400
Subject: [PATCH] trace: create tracers menu
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Oct 2008 16:31:18 +0200
Message-Id: <1224599478.22771.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: trace: create tracers menu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Oct 21 16:26:36 CEST 2008

We seem to have plenty tracers, lets create a menu and not clutter
the already cluttered debug menu more.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/kernel/trace/Kconfig
===================================================================
--- linux-2.6.orig/kernel/trace/Kconfig
+++ linux-2.6/kernel/trace/Kconfig
@@ -29,6 +29,8 @@ config TRACING
 	select STACKTRACE
 	select TRACEPOINTS
 
+menu "Tracers"
+
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
@@ -191,3 +193,5 @@ config FTRACE_STARTUP_TEST
 	  a series of tests are made to verify that the tracer is
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
+
+endmenu

