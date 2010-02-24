Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0BXH2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:28:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53071 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab0BXH2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:28:06 -0500
Message-ID: <4B84D50E.4070806@cn.fujitsu.com>
Date: Wed, 24 Feb 2010 15:28:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Remove CONFIG_TRACE_POWER from kernel config
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power tracer has been converted to power trace events.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/Kconfig |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 928b289..745d01c 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -341,15 +341,6 @@ config BRANCH_TRACER
 
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
1.6.3

