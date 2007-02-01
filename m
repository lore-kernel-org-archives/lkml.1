Return-Path: <linux-kernel-owner+w=401wt.eu-S1422888AbXBANxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422888AbXBANxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422880AbXBANxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:53:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40132 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422883AbXBANwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:52:49 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] fork_idle() should be __cpuinit, not __devinit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HCcMq-0007RX-W3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:52:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index fc723e5..d57118d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1313,7 +1313,7 @@ noinline struct pt_regs * __devinit __attribute__((weak)) idle_regs(struct pt_re
 	return regs;
 }
 
-struct task_struct * __devinit fork_idle(int cpu)
+struct task_struct * __cpuinit fork_idle(int cpu)
 {
 	struct task_struct *task;
 	struct pt_regs regs;
-- 
1.5.0-rc2.GIT


