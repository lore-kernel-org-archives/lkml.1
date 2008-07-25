Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYGYCL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYGYCL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYGYCLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:11:52 -0400
Received: from ozlabs.org ([203.10.76.45]:48124 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYGYCLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:11:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Label kthread_create() with printf attribute tag.
Date: Fri, 25 Jul 2008 12:11:09 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251211.09433.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obvious misc patch been in my queue (& linux-next) for over a cycle.

Linus please apply.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/kthread.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -r 9b5082037972 include/linux/kthread.h
--- a/include/linux/kthread.h	Mon Apr 07 17:06:45 2008 +1000
+++ b/include/linux/kthread.h	Mon Apr 07 17:07:09 2008 +1000
@@ -6,7 +6,8 @@
 
 struct task_struct *kthread_create(int (*threadfn)(void *data),
 				   void *data,
-				   const char namefmt[], ...);
+				   const char namefmt[], ...)
+	__attribute__((format(printf, 3, 4)));
 
 /**
  * kthread_run - create and wake a thread.
