Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXK2QEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXK2QEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbXK2QEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:04:45 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37633 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbXK2QEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:04:44 -0500
Date: Thu, 29 Nov 2007 17:04:35 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove one useless extern declaration
Message-Id: <20071129170435.2f79a833.pierre.peiffer@bull.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/11/2007 17:12:05,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/11/2007 17:12:05,
	Serialize complete at 29/11/2007 17:12:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



The file exit.c contains one useless extern declaration of sem_exit().
Moreover, it refers to nothing.

This trivial patch removes it.


Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
---
 kernel/exit.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/kernel/exit.c
===================================================================
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -50,8 +50,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-extern void sem_exit (void);
-
 static void exit_mm(struct task_struct * tsk);
 
 static void __unhash_process(struct task_struct *p)

-- 
Pierre Peiffer
