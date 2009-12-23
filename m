Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZLWVWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZLWVWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbZLWVWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:22:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:45326 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086AbZLWVVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:54 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 11/37] kgdb: Fix kernel-doc format error in kgdb.h
Date: Wed, 23 Dec 2009 15:19:24 -0600
Message-Id: <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:09.0895 (UTC) FILETIME=[B4FA1B70:01CA8415]
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
 include/linux/kgdb.h |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 4247950..cedae0b 100644
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
@@ -295,8 +294,7 @@ extern int __weak kgdb_mem2hex(char *mem, char *buf, int count);
 extern int __weak kgdb_hex2mem(char *buf, char *mem, int count);
 
 /**
- *      kgdb_ebin2mem - (optional arch override) Copy the binary array
- *     pointed to by buf into mem.
+ *      kgdb_ebin2mem - (optional arch override) Copy binary array from @buf into @mem
  *      @buf: source buffer
  *      @mem: target buffer
  *      @count: number of bytes in mem
-- 
1.6.4.rc1

