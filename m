Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab0BYTpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:45:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab0BYTpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:45:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=3EKuxbvGHaEA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=Y4SbCxkhsbhYw7GI3NQA:9 a=abrAKtPoK5JvDVP86arL_aJUWCwA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225194529.165695229@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:43:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/7] tracing: Remove CONFIG_TRACE_POWER from kernel config
References: <20100225194355.707261669@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-CONFIG_TRACE_POWER-from-kernel-config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
-- 
1.6.5


