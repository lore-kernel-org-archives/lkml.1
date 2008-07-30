Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYG3LZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYG3LZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbYG3LZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:25:41 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47903 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbYG3LZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:25:41 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xsonnek@gmail.com,
       Jiri Slaby <jirislaby@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/1] semaphore: declare down_try
Date: Wed, 30 Jul 2008 13:25:15 +0200
Message-Id: <1217417115-28574-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe you already fixed this, in todays mmotm there is a fix of duplicate
down_try definiton, but this problem still persist.
--

down_trylock is superseded by down_try, but prototypes in header
files remained unchanged.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/semaphore.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 7415839..ca153ec 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -42,7 +42,7 @@ static inline void sema_init(struct semaphore *sem, int val)
 extern void down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
-extern int __must_check down_trylock(struct semaphore *sem);
+extern int __must_check down_try(struct semaphore *sem);
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
 
-- 
1.5.6.2

