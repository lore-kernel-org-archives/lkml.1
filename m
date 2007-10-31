Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXJaUAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXJaUAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbXJaT77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:59:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48818 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbXJaT75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:59:57 -0400
Date: Wed, 31 Oct 2007 15:59:38 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/4] UML - Remove last include of libc asm/page.h
Message-ID: <20071031195938.GA9635@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

asm/page.h is disappearing from the libc headers and we don't need it anyway.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/skas/clone.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.22/arch/um/kernel/skas/clone.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/skas/clone.c	2007-10-12 12:09:00.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/skas/clone.c	2007-10-23 12:09:33.000000000 -0400
@@ -3,7 +3,6 @@
 #include <sys/mman.h>
 #include <sys/time.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "as-layout.h"
 #include "ptrace_user.h"
 #include "skas.h"
