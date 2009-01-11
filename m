Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbZAKJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbZAKJEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZAKJE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:04:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:24923 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZAKJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:04:26 -0500
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH -tip 1/2] kernel/fork.c: unused variable 'ret'
Date: Sun, 11 Jan 2009 01:04:21 -0800
Message-Id: <1231664662-17104-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the unused variable.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 kernel/fork.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ce4003a..fb1f5e9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -822,7 +822,6 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
-	int ret;
 
 	if (clone_flags & CLONE_THREAD) {
 		atomic_inc(&current->signal->count);
-- 
1.6.1

