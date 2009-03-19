Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbZCSVKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbZCSVKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760869AbZCSVJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:09:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33457 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760621AbZCSVJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:09:42 -0400
Message-ID: <49C2B4BF.4080904@redhat.com>
Date: Thu, 19 Mar 2009 17:10:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC][PATCH -tip 4/9] power: add kernel_trap_sp()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel_trap_sp() on powerpc, based on systemtap's runtime/regs.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/powerpc/include/asm/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index c9c678f..0ac366c 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -83,6 +83,7 @@ struct pt_regs {

 #define instruction_pointer(regs) ((regs)->nip)
 #define user_stack_pointer(regs) ((regs)->gpr[1])
+#define kernel_trap_sp(regs) (user_stack_pointer(regs))
 #define regs_return_value(regs) ((regs)->gpr[3])

 #ifdef CONFIG_SMP
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


