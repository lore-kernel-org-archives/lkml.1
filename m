Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbYGQP3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbYGQP3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYGQP31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:29:27 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:49413 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYGQP30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:29:26 -0400
Date: Fri, 18 Jul 2008 00:31:08 +0900 (JST)
Message-Id: <20080718.003108.128619119.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Fix build on COMPAT platforms when CONFIG_EPOLL is
 disabled.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing cond_syscall() entry for compat_sys_epoll_pwait.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5b9b467..0fea0ee 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -59,6 +59,7 @@ cond_syscall(sys_epoll_create);
 cond_syscall(sys_epoll_ctl);
 cond_syscall(sys_epoll_wait);
 cond_syscall(sys_epoll_pwait);
+cond_syscall(compat_sys_epoll_pwait);
 cond_syscall(sys_semget);
 cond_syscall(sys_semop);
 cond_syscall(sys_semtimedop);
