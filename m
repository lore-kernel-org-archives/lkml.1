Return-Path: <linux-kernel-owner+w=401wt.eu-S1161197AbXBGLYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161197AbXBGLYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161207AbXBGLYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:24:09 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:5258 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161197AbXBGLYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:24:06 -0500
Date: Wed, 7 Feb 2007 12:23:01 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] lockdep: forward declare struct trask_struct
Message-ID: <20070207112301.GA9212@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

3117df0453828bd045c16244e6f50e5714667a8a causes this:

In file included from arch/s390/kernel/early.c:13:
include/linux/lockdep.h:300: warning:
		"struct task_struct" declared inside parameter list
include/linux/lockdep.h:300:
		warning: its scope is only this definition or
		declaration, which is probably not what you want

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/lockdep.h |    2 ++
 1 files changed, 2 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -286,6 +286,8 @@ static inline void early_init_irq_lock_c
 }
 #endif
 
+struct task_struct;
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 extern void early_boot_irqs_off(void);
 extern void early_boot_irqs_on(void);
