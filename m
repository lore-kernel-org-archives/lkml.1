Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYKDWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYKDWmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYKDWmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:42:09 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33189 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYKDWmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:42:08 -0500
Message-ID: <4910CC83.6060803@oracle.com>
Date: Tue, 04 Nov 2008 14:28:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, kgdb-bugreport@lists.sourceforge.net
CC: jason.wessel@windriver.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next resend] kgdb: fix kernel-docs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,
This is still needed in linux-next.  Please merge it so that
Stephen picks it up in linux-next.


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc format error in kgdb.h:

linux-next-20081022//include/linux/kgdb.h:308): duplicate section name 'Description'

and fix typos in that file's kernel-doc comments.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-next-20081022.orig/include/linux/kgdb.h
+++ linux-next-20081022/include/linux/kgdb.h
@@ -29,8 +29,7 @@ struct pt_regs;
  *
  *	On some architectures it is required to skip a breakpoint
  *	exception when it occurs after a breakpoint has been removed.
- *	This can be implemented in the architecture specific portion of
- *	for kgdb.
+ *	This can be implemented in the architecture specific portion of kgdb.
  */
 extern int kgdb_skipexception(int exception, struct pt_regs *regs);
 
@@ -42,7 +41,7 @@ extern int kgdb_skipexception(int except
  *
  *	This is usually needed on architectures which support SMP and
  *	KGDB.  This function is called after all the secondary cpus have
- *	been put to a know spin state and the primary CPU has control over
+ *	been put to a known spin state and the primary CPU has control over
  *	KGDB.
  */
 extern void kgdb_post_primary_code(struct pt_regs *regs, int e_vector,
@@ -65,7 +64,7 @@ struct uart_port;
 /**
  *	kgdb_breakpoint - compiled in breakpoint
  *
- *	This will be impelmented a static inline per architecture.  This
+ *	This will be implemented as a static inline per architecture.  This
  *	function is called by the kgdb core to execute an architecture
  *	specific trap to cause kgdb to enter the exception processing.
  *
@@ -190,7 +189,7 @@ kgdb_arch_handle_exception(int vector, i
  *	@flags: Current IRQ state
  *
  *	On SMP systems, we need to get the attention of the other CPUs
- *	and get them be in a known state.  This should do what is needed
+ *	and get them into a known state.  This should do what is needed
  *	to get the other CPUs to call kgdb_wait(). Note that on some arches,
  *	the NMI approach is not used for rounding up all the CPUs. For example,
  *	in case of MIPS, smp_call_function() is used to roundup CPUs. In
@@ -295,8 +294,7 @@ extern int __weak kgdb_mem2hex(char *mem
 extern int __weak kgdb_hex2mem(char *buf, char *mem, int count);
 
 /**
- *      kgdb_ebin2mem - (optional arch override) Copy the binary array
- *     pointed to by buf into mem.
+ *      kgdb_ebin2mem - (optional arch override) Copy binary array from @buf into @mem
  *      @buf: source buffer
  *      @mem: target buffer
  *      @count: number of bytes in mem
