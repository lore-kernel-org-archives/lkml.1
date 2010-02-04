Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0BDJy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:54:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:52156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab0BDJyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:54:24 -0500
Date: Thu, 4 Feb 2010 09:52:15 GMT
From: tip-bot for Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, arjan@linux.intel.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       adobriyan@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       adobriyan@gmail.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86_64: Print modules like i386 does
Message-ID: <tip-f266d7f5f89652a68e21e9882c44ee9104ad8d61@git.kernel.org>
Git-Commit-ID: f266d7f5f89652a68e21e9882c44ee9104ad8d61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f266d7f5f89652a68e21e9882c44ee9104ad8d61
Gitweb:     http://git.kernel.org/tip/f266d7f5f89652a68e21e9882c44ee9104ad8d61
Author:     Alexey Dobriyan <adobriyan@gmail.com>
AuthorDate: Wed, 3 Feb 2010 21:21:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:27:56 +0100

x86_64: Print modules like i386 does

Print modules list during kernel BUG.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/dumpstack_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 0ad9597..907a90e 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -291,6 +291,7 @@ void show_registers(struct pt_regs *regs)
 
 	sp = regs->sp;
 	printk("CPU %d ", cpu);
+	print_modules();
 	__show_regs(regs, 1);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
 		cur->comm, cur->pid, task_thread_info(cur), cur);
