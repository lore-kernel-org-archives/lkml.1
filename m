Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbZD2VW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbZD2VW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZD2VWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:22:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:53791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbZD2VWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:22:16 -0400
Date: Wed, 29 Apr 2009 21:21:45 GMT
From: tip-bot for Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090429205451.GA23154@hades.domain.com>
References: <20090429205451.GA23154@hades.domain.com>
Subject: [tip:core/locking] locking, rtmutex.c: Documentation cleanup
Message-ID: <tip-23b94b967f118bef941369238f33c8140be46539@git.kernel.org>
Git-Commit-ID: 23b94b967f118bef941369238f33c8140be46539
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 21:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23b94b967f118bef941369238f33c8140be46539
Gitweb:     http://git.kernel.org/tip/23b94b967f118bef941369238f33c8140be46539
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Wed, 29 Apr 2009 21:54:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 23:20:17 +0200

locking, rtmutex.c: Documentation cleanup

Two minor updates on functions documentation:
 - Updated documentation for function rt_mutex_unlock(), which contained an
   incorrect name
 - Removed extra '*' from comment in function rt_mutex_destroy()

[ Impact: cleanup ]

Signed-off-by: Luis Henriques <henrix@sapo.pt>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090429205451.GA23154@hades.domain.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rtmutex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 69d9cb9..013882e 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -864,9 +864,9 @@ int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
 /**
- * rt_mutex_lock_interruptible_ktime - lock a rt_mutex interruptible
- *				       the timeout structure is provided
- *				       by the caller
+ * rt_mutex_timed_lock - lock a rt_mutex interruptible
+ *			the timeout structure is provided
+ *			by the caller
  *
  * @lock: 		the rt_mutex to be locked
  * @timeout:		timeout structure or NULL (no timeout)
@@ -913,7 +913,7 @@ void __sched rt_mutex_unlock(struct rt_mutex *lock)
 }
 EXPORT_SYMBOL_GPL(rt_mutex_unlock);
 
-/***
+/**
  * rt_mutex_destroy - mark a mutex unusable
  * @lock: the mutex to be destroyed
  *
