Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZDDRjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZDDRjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZDDRi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:38:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37374 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZDDRi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:38:57 -0400
Date: Sat, 4 Apr 2009 19:38:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, srinivasa@in.ibm.com
Cc: akpm@osdl.org
Subject: [PATCH] Update NSIGTRAP in asm-generic/siginfo.h
Message-ID: <20090404173849.GA2040@basil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update NSIGTRAP in asm-generic/siginfo.h

Impact: (nearly) trivial

The patch

commit da654b74bda14c45a7d98c731bf3c1a43b6b74e2
Author: Srinivasa Ds <srinivasa@in.ibm.com>
Date:   Tue Sep 23 15:23:52 2008 +0530

    signals: demultiplexing SIGTRAP signal

forgot to update the NSIGTRAP define in asm-generic/siginfo.h to 
the new number of sigtrap subcodes. Nothing in the tree seems to use it, 
but presumably something in user space might. So update it.

Cc: Srinivasa Ds <srinivasa@in.ibm.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-generic/siginfo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.29-ak/include/asm-generic/siginfo.h
===================================================================
--- linux-2.6.29-ak.orig/include/asm-generic/siginfo.h	2008-10-24 13:34:57.000000000 +0200
+++ linux-2.6.29-ak/include/asm-generic/siginfo.h	2009-04-04 19:35:23.000000000 +0200
@@ -201,7 +201,7 @@
 #define TRAP_TRACE	(__SI_FAULT|2)	/* process trace trap */
 #define TRAP_BRANCH     (__SI_FAULT|3)  /* process taken branch trap */
 #define TRAP_HWBKPT     (__SI_FAULT|4)  /* hardware breakpoint/watchpoint */
-#define NSIGTRAP	2
+#define NSIGTRAP	4
 
 /*
  * SIGCHLD si_codes
