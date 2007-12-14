Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbXLNQSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbXLNQSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934139AbXLNQRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:17:41 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:41477 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762328AbXLNQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:17:39 -0500
Date: Fri, 14 Dec 2007 11:16:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] UML - Add asm/fixmap.h include
Message-ID: <20071214161647.GA5802@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This needs to go into 2.6.24, as it fixes a build breakage seen on x86_64 ]

um_uaccess.h refers to FIXADDR_USER_*, so it should include fixmap.h.

I also changed the non-UML includes to use <> instead of "".

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/um_uaccess.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/include/um_uaccess.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/um_uaccess.h	2007-12-13 10:09:22.000000000 -0500
+++ linux-2.6.22/arch/um/include/um_uaccess.h	2007-12-13 15:11:42.000000000 -0500
@@ -6,7 +6,8 @@
 #ifndef __ARCH_UM_UACCESS_H
 #define __ARCH_UM_UACCESS_H
 
-#include "asm/elf.h"
+#include <asm/elf.h>
+#include <asm/fixmap.h>
 #include "sysdep/archsetjmp.h"
 
 #define __under_task_size(addr, size) \
