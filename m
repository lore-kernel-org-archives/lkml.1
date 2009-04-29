Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZD2U6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZD2U6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZD2U6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:58:13 -0400
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:37581 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751538AbZD2U6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:58:12 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 29 Apr 2009 21:54:51 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: [[PATCH -tip] rtmutex.c: Documentation cleanup
Message-ID: <20090429205451.GA23154@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two minor updates on functions documentation:
 - Updated documentation for function rt_mutex_unlock(), which contained an
   incorrect name
 - Removed extra '*' from comment in function rt_mutex_destroy()

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/rtmutex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index fec77e7..820c5af 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -891,9 +891,9 @@ int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
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
@@ -940,7 +940,7 @@ void __sched rt_mutex_unlock(struct rt_mutex *lock)
 }
 EXPORT_SYMBOL_GPL(rt_mutex_unlock);
 
-/***
+/**
  * rt_mutex_destroy - mark a mutex unusable
  * @lock: the mutex to be destroyed
  *
-- 
1.6.2.4

