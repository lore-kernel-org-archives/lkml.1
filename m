Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZF2Hyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZF2Hyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2HyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:54:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57253 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757333AbZF2HyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:54:19 -0400
Message-ID: <4A48735E.9050002@cn.fujitsu.com>
Date: Mon, 29 Jun 2009 15:55:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/fastboot: document the need of initcall_debug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To use boot tracer, one should pass initcall_debug as well as
ftrace=initcall to the command line.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index f7d9a4e..860c712 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -226,13 +226,13 @@ config BOOT_TRACER
 	  the timings of the initcalls and traces key events and the identity
 	  of tasks that can cause boot delays, such as context-switches.
 
-	  Its aim is to be parsed by the /scripts/bootgraph.pl tool to
+	  Its aim is to be parsed by the scripts/bootgraph.pl tool to
 	  produce pretty graphics about boot inefficiencies, giving a visual
 	  representation of the delays during initcalls - but the raw
 	  /debug/tracing/trace text output is readable too.
 
-	  You must pass in ftrace=initcall to the kernel command line
-	  to enable this on bootup.
+	  You must pass in initcall_debug and ftrace=initcall to the kernel
+	  command line to enable this on bootup.
 
 config TRACE_BRANCH_PROFILING
 	bool
-- 
1.5.4.rc3

