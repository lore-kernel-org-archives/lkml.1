Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbYAJIgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbYAJIgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYAJIf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:35:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:32108 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYAJIf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:35:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SPoCrQ6YENUfF9iocjT13A77wG3c/5zbZ7z0XnBPJXYappokSVUjMnNRk0o8VT8jgLCjTAp/U7Bf/QM3rsz4FrJwaUETnc5hfWUwsz/Gb/mdjSnZeAzE+2DoNPIn97NUbMQAMFafig3RyVZa2551/vrtMlzKthInuoqOZZib8uw=
Subject: [PATCH] x86: trivial whitespace in kprobes.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 00:35:57 -0800
Message-Id: <1199954157.19760.22.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, you could/should probably fold this into Masami's kprobe
unification patch.

commit 17735e04f7f18bea4dcbe4daa31c34acac55b332
Author: Masami Hiramatsu <mhiramat@redhat.com>
Date:   Wed Jan 9 13:30:50 2008 +0100

    kprobes code for x86 unification

in current(ish) x86.git

 arch/x86/kernel/kprobes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 53ba6a5..93aff49 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -583,8 +583,8 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
- void __kprobes kretprobe_trampoline_holder(void)
- {
+void __kprobes kretprobe_trampoline_holder(void)
+{
 	asm volatile (
 			".global kretprobe_trampoline\n"
 			"kretprobe_trampoline: \n"
@@ -670,7 +670,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			"	popf\n"
 #endif
 			"	ret\n");
- }
+}
 
 /*
  * Called from kretprobe_trampoline
-- 
1.5.4.rc2.1164.g6451

