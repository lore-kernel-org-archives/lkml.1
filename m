Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZDYAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZDYAIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZDYAIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:08:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZDYAIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:08:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 02/17] arm: arch_ptrace indentation
Message-Id: <20090425000801.254D1FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:08:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the arch_ptrace() indentation to match the standard style.
No change but the whitespace.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |  116 +++++++++++++++++++++++-----------------------
 1 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 825b7ab..93d7822 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -706,13 +706,13 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	int ret;
 
 	switch (request) {
-		case PTRACE_PEEKUSR:
-			ret = ptrace_read_user(child, addr, (unsigned long __user *)data);
-			break;
+	case PTRACE_PEEKUSR:
+		ret = ptrace_read_user(child, addr, (unsigned long __user *)data);
+		break;
 
-		case PTRACE_POKEUSR:
-			ret = ptrace_write_user(child, addr, data);
-			break;
+	case PTRACE_POKEUSR:
+		ret = ptrace_write_user(child, addr, data);
+		break;
 
 		/*
 		 * The generic code handles these mostly, but we have to
@@ -723,11 +723,11 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		 * come back through here or PTRACE_SINGLESTEP again
 		 * before it matters.
 		 */
-		case PTRACE_SYSCALL:
-		case PTRACE_CONT:
-		case PTRACE_KILL:
-			single_step_disable(child);
-			goto common;
+	case PTRACE_SYSCALL:
+	case PTRACE_CONT:
+	case PTRACE_KILL:
+		single_step_disable(child);
+		goto common;
 
 		/*
 		 * After we set up single-step state, the generic
@@ -735,71 +735,71 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		 * Note as above we don't bother with checking early
 		 * for the error case.
 		 */
-		case PTRACE_SINGLESTEP:
-			single_step_enable(child);
-			request = PTRACE_CONT;
-			goto common;
+	case PTRACE_SINGLESTEP:
+		single_step_enable(child);
+		request = PTRACE_CONT;
+		goto common;
 
-		case PTRACE_GETREGS:
-			ret = ptrace_getregs(child, (void __user *)data);
-			break;
+	case PTRACE_GETREGS:
+		ret = ptrace_getregs(child, (void __user *)data);
+		break;
 
-		case PTRACE_SETREGS:
-			ret = ptrace_setregs(child, (void __user *)data);
-			break;
+	case PTRACE_SETREGS:
+		ret = ptrace_setregs(child, (void __user *)data);
+		break;
 
-		case PTRACE_GETFPREGS:
-			ret = ptrace_getfpregs(child, (void __user *)data);
-			break;
-		
-		case PTRACE_SETFPREGS:
-			ret = ptrace_setfpregs(child, (void __user *)data);
-			break;
+	case PTRACE_GETFPREGS:
+		ret = ptrace_getfpregs(child, (void __user *)data);
+		break;
+
+	case PTRACE_SETFPREGS:
+		ret = ptrace_setfpregs(child, (void __user *)data);
+		break;
 
 #ifdef CONFIG_IWMMXT
-		case PTRACE_GETWMMXREGS:
-			ret = ptrace_getwmmxregs(child, (void __user *)data);
-			break;
+	case PTRACE_GETWMMXREGS:
+		ret = ptrace_getwmmxregs(child, (void __user *)data);
+		break;
 
-		case PTRACE_SETWMMXREGS:
-			ret = ptrace_setwmmxregs(child, (void __user *)data);
-			break;
+	case PTRACE_SETWMMXREGS:
+		ret = ptrace_setwmmxregs(child, (void __user *)data);
+		break;
 #endif
 
-		case PTRACE_GET_THREAD_AREA:
-			ret = put_user(task_thread_info(child)->tp_value,
-				       (unsigned long __user *) data);
-			break;
+	case PTRACE_GET_THREAD_AREA:
+		ret = put_user(task_thread_info(child)->tp_value,
+			       (unsigned long __user *) data);
+		break;
 
-		case PTRACE_SET_SYSCALL:
-			task_thread_info(child)->syscall = data;
-			ret = 0;
-			break;
+	case PTRACE_SET_SYSCALL:
+		task_thread_info(child)->syscall = data;
+		ret = 0;
+		break;
 
 #ifdef CONFIG_CRUNCH
-		case PTRACE_GETCRUNCHREGS:
-			ret = ptrace_getcrunchregs(child, (void __user *)data);
-			break;
+	case PTRACE_GETCRUNCHREGS:
+		ret = ptrace_getcrunchregs(child, (void __user *)data);
+		break;
 
-		case PTRACE_SETCRUNCHREGS:
-			ret = ptrace_setcrunchregs(child, (void __user *)data);
-			break;
+	case PTRACE_SETCRUNCHREGS:
+		ret = ptrace_setcrunchregs(child, (void __user *)data);
+		break;
 #endif
 
 #ifdef CONFIG_VFP
-		case PTRACE_GETVFPREGS:
-			ret = ptrace_getvfpregs(child, (void __user *)data);
-			break;
+	case PTRACE_GETVFPREGS:
+		ret = ptrace_getvfpregs(child, (void __user *)data);
+		break;
 
-		case PTRACE_SETVFPREGS:
-			ret = ptrace_setvfpregs(child, (void __user *)data);
-			break;
+	case PTRACE_SETVFPREGS:
+		ret = ptrace_setvfpregs(child, (void __user *)data);
+		break;
 #endif
 
-		default:
-		common:
-			ret = ptrace_request(child, request, addr, data);
-			break;
+	default:
+	common:
+		ret = ptrace_request(child, request, addr, data);
+		break;
 	}
 
 	return ret;
