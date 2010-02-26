Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935712Ab0BZJ2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:28:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:39753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935668Ab0BZJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:28:36 -0500
Date: Fri, 26 Feb 2010 09:28:06 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B84D50E.4070806@cn.fujitsu.com>
References: <4B84D50E.4070806@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Remove CONFIG_TRACE_POWER from kernel config
Message-ID: <tip-1ab83a89411556c4d5914dcf0d5da190178ae7db@git.kernel.org>
Git-Commit-ID: 1ab83a89411556c4d5914dcf0d5da190178ae7db
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:28:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ab83a89411556c4d5914dcf0d5da190178ae7db
Gitweb:     http://git.kernel.org/tip/1ab83a89411556c4d5914dcf0d5da190178ae7db
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Feb 2010 15:28:14 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 25 Feb 2010 10:31:45 -0500

tracing: Remove CONFIG_TRACE_POWER from kernel config

The power tracer has been converted to power trace events.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B84D50E.4070806@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 6c22d8a..ca2d3a8 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -330,15 +330,6 @@ config BRANCH_TRACER
 
 	  Say N if unsure.
 
-config POWER_TRACER
-	bool "Trace power consumption behavior"
-	depends on X86
-	select GENERIC_TRACER
-	help
-	  This tracer helps developers to analyze and optimize the kernel's
-	  power management decisions, specifically the C-state and P-state
-	  behavior.
-
 config KSYM_TRACER
 	bool "Trace read and write access on kernel memory locations"
 	depends on HAVE_HW_BREAKPOINT
