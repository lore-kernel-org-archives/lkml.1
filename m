Return-Path: <linux-kernel-owner+w=401wt.eu-S1423567AbXEATk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423567AbXEATk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423577AbXEATk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:40:57 -0400
Received: from [198.99.130.12] ([198.99.130.12]:38706 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1423567AbXEATk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:40:56 -0400
Date: Tue, 1 May 2007 15:36:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - forgot asm-um/cmpxchg.h
Message-ID: <20070501193646.GA9482@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The i386 and x86_64 cmpxchg patches require an asm-um/cmpxchg.h for
the UML build.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/cmpxchg.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.21-mm/include/asm-um/cmpxchg.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-mm/include/asm-um/cmpxchg.h	2007-05-01 15:31:09.000000000 -0400
@@ -0,0 +1,6 @@
+#ifndef __UM_CMPXCHG_H
+#define __UM_CMPXCHG_H
+
+#include "asm/arch/cmpxchg.h"
+
+#endif
