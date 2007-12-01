Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbXLAKjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbXLAKjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 05:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXLAKjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 05:39:40 -0500
Received: from sacred.ru ([62.205.161.221]:35660 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbXLAKjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 05:39:40 -0500
Message-ID: <475139D0.9080900@openvz.org>
Date: Sat, 01 Dec 2007 13:39:12 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <trivial@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH] Remove unneeded extern declaration from kernel/exit.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Sat, 01 Dec 2007 13:39:15 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The declared extern void sem_exit(void) function does 
not even exist in the kernel.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/exit.c b/kernel/exit.c
index 549c055..a2213c3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -50,8 +50,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-extern void sem_exit (void);
-
 static void exit_mm(struct task_struct * tsk);
 
 static void __unhash_process(struct task_struct *p)
