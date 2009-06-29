Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZF2IZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZF2IZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZF2IZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:25:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:53982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbZF2IZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:25:07 -0400
Date: Mon, 29 Jun 2009 08:24:31 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A48735E.9050002@cn.fujitsu.com>
References: <4A48735E.9050002@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/fastboot: Document the need of initcall_debug
Message-ID: <tip-238a24f626628cb16a3015f332d649f08246ca89@git.kernel.org>
Git-Commit-ID: 238a24f626628cb16a3015f332d649f08246ca89
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 08:24:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  238a24f626628cb16a3015f332d649f08246ca89
Gitweb:     http://git.kernel.org/tip/238a24f626628cb16a3015f332d649f08246ca89
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 29 Jun 2009 15:55:10 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 10:22:10 +0200

tracing/fastboot: Document the need of initcall_debug

To use boot tracer, one should pass initcall_debug as well as
ftrace=initcall to the command line.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A48735E.9050002@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1551f47..019f380 100644
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
