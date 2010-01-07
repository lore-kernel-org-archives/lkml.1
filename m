Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605Ab0AGTBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0AGTBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548Ab0AGTBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:01:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:60328 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab0AGTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:01:28 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 4/4] kgdb: Fix kernel-doc format error in kgdb.h
Date: Thu,  7 Jan 2010 12:59:56 -0600
Message-Id: <1262890796-25053-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
References: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Jan 2010 19:00:42.0861 (UTC) FILETIME=[B60849D0:01CA8FCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

linux-next-20081022//include/linux/kgdb.h:308): duplicate section name 'Description'

and fix typos in that file's kernel-doc comments.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6adcc29..19ec41a 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -29,8 +29,7 @@ struct pt_regs;
  *
  *	On some architectures it is required to skip a breakpoint
  *	exception when it occurs after a breakpoint has been removed.
- *	This can be implemented in the architecture specific portion of
- *	for kgdb.
+ *	This can be implemented in the architecture specific portion of kgdb.
  */
 extern int kgdb_skipexception(int exception, struct pt_regs *regs);
 
@@ -65,7 +64,7 @@ struct uart_port;
 /**
  *	kgdb_breakpoint - compiled in breakpoint
  *
- *	This will be impelmented a static inline per architecture.  This
+ *	This will be implemented as a static inline per architecture.  This
  *	function is called by the kgdb core to execute an architecture
  *	specific trap to cause kgdb to enter the exception processing.
  *
@@ -190,7 +189,7 @@ kgdb_arch_handle_exception(int vector, int signo, int err_code,
  *	@flags: Current IRQ state
  *
  *	On SMP systems, we need to get the attention of the other CPUs
- *	and get them be in a known state.  This should do what is needed
+ *	and get them into a known state.  This should do what is needed
  *	to get the other CPUs to call kgdb_wait(). Note that on some arches,
  *	the NMI approach is not used for rounding up all the CPUs. For example,
  *	in case of MIPS, smp_call_function() is used to roundup CPUs. In
-- 
1.6.3.1.9.g95405b

