Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZDNKDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZDNKDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZDNKBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:01:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:45774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbZDNKBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:01:54 -0400
Date: Tue, 14 Apr 2009 10:01:22 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, nhorman@tuxdriver.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, nhorman@tuxdriver.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239695308.3033.34.camel@ht.satnam>
References: <1239695308.3033.34.camel@ht.satnam>
Subject: [tip:x86/cleanups] x86: avoid multiple declaration of kstack_depth_to_print
Message-ID: <tip-e7d43a74cb07cbc4b8e9b5e4a914816b33fb0719@git.kernel.org>
Git-Commit-ID: e7d43a74cb07cbc4b8e9b5e4a914816b33fb0719
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 10:01:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7d43a74cb07cbc4b8e9b5e4a914816b33fb0719
Gitweb:     http://git.kernel.org/tip/e7d43a74cb07cbc4b8e9b5e4a914816b33fb0719
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Tue, 14 Apr 2009 13:18:28 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:45:33 +0200

x86: avoid multiple declaration of kstack_depth_to_print

Impact: cleanup

asm/stacktrace.h is more appropriate so removing other 2 declarations.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
LKML-Reference: <1239695308.3033.34.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/traps.h |    1 -
 arch/x86/kernel/dumpstack.h  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0d53425..9aa3ab2 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -74,7 +74,6 @@ static inline int get_si_code(unsigned long condition)
 }
 
 extern int panic_on_unrecovered_nmi;
-extern int kstack_depth_to_print;
 
 void math_error(void __user *);
 void math_emulate(struct math_emu_info *);
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index da87590..81086c2 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -29,7 +29,6 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *sp, unsigned long bp, char *log_lvl);
 
 extern unsigned int code_bytes;
-extern int kstack_depth_to_print;
 
 /* The form of the top of the frame on the stack */
 struct stack_frame {
