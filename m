Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbYCWIvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbYCWIvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbYCWILi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:38 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2334 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760089AbYCWILc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:32 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 018/148] include/asm-x86/compat.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:53 -0700
Message-Id: <1206259443-13210-19-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/compat.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/compat.h b/include/asm-x86/compat.h
index d3e8f3e..1793ac3 100644
--- a/include/asm-x86/compat.h
+++ b/include/asm-x86/compat.h
@@ -204,7 +204,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-static __inline__ void __user *compat_alloc_user_space(long len)
+static inline void __user *compat_alloc_user_space(long len)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	return (void __user *)regs->sp - len;
-- 
1.5.4.rc2

