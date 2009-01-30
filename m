Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZA3JV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZA3JV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZA3JVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:21:42 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:12638 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZA3JVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nWczH/MdIZ07CQKKJor0P7GaQHSELwU7n58WfelySfh6pgFYIyHPBO9dkPV4NUJZx2
         UdWNIdKmNyAPsGVSQon0WXUqwdvsH4LOVaN271r/OxUsIwDQZNwl6etVIYkydYi2mW6c
         /2Q98XlWhFFcx9BgvsjCJlXLvkjDk9BKbTLJQ=
Date: Fri, 30 Jan 2009 17:21:15 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: [trival patch] x86: remove unless include and comments
Message-ID: <20090130092115.GB16225@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a546f55..e306105 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,8 +9,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -631,9 +629,6 @@ asmlinkage int sys_vfork(struct pt_regs regs)
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
 }
 
-/*
- * sys_execve() executes a new program.
- */
 asmlinkage int sys_execve(struct pt_regs regs)
 {
 	int error;

