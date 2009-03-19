Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbZCSVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbZCSVMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761323AbZCSVKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:10:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33479 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761152AbZCSVKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:10:06 -0400
Message-ID: <49C2B4CC.7030106@redhat.com>
Date: Thu, 19 Mar 2009 17:10:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC][PATCH -tip 6/9] arm: add kernel_trap_sp()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel_trap_sp() on ARM, based on systemtap's runtime/regs.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/include/asm/ptrace.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 7319261..14e0e16 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -138,7 +138,8 @@ static inline int valid_user_regs(struct pt_regs *regs)
 	return 0;
 }

-#define instruction_pointer(regs)	(regs)->ARM_pc
+#define instruction_pointer(regs)	((regs)->ARM_pc)
+#define kernel_trap_sp(regs)		((regs)->ARM_sp)

 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


