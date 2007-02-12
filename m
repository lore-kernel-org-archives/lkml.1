Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXBLHr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXBLHr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXBLHqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:51 -0500
Received: from ns.suse.de ([195.135.220.2]:38374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080AbXBLHh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:56 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [9/39] x86_64: Use constant instead of raw number in x86_64 ioperm.c
Message-Id: <20070212073755.899C913D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Glauber de Oliveira Costa <gcosta@redhat.com>

This is a tiny cleanup to increase readability

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/ioport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86_64/kernel/ioport.c
===================================================================
--- linux.orig/arch/x86_64/kernel/ioport.c
+++ linux/arch/x86_64/kernel/ioport.c
@@ -114,6 +114,6 @@ asmlinkage long sys_iopl(unsigned int le
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
 	}
-	regs->eflags = (regs->eflags &~ 0x3000UL) | (level << 12);
+	regs->eflags = (regs->eflags &~ X86_EFLAGS_IOPL) | (level << 12);
 	return 0;
 }
