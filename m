Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXKUCxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXKUCxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXKUCxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:53:01 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55670 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXKUCxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:53:00 -0500
Subject: [PATCH] remove unused tsk_thread from asm-offsets_64.c
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 21:52:32 -0500
Message-Id: <1195613552.13982.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking for where tsk_thread is used in the x86_64 code, and
couln't find it anywhere. I took it out and compiled the kernel, and it
compiled fine.

So this patch simply removes the "thread" from asm-offsets.c since I
can't find an owner for it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index d1b6ed9..40f4175 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -38,7 +38,6 @@ int main(void)
 #define ENTRY(entry) DEFINE(tsk_ ## entry, offsetof(struct task_struct, entry))
 	ENTRY(state);
 	ENTRY(flags); 
-	ENTRY(thread); 
 	ENTRY(pid);
 	BLANK();
 #undef ENTRY


