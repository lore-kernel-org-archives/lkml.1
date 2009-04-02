Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbZDBEEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbZDBEEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZDBEEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:04:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:56742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZDBEEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:04:12 -0400
Date: Thu, 2 Apr 2009 03:57:44 GMT
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johannes@sipsolutions.net, akpm@linux-foundation.org,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, johannes@sipsolutions.net,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <20090401174723.f0bea0eb.randy.dunlap@oracle.com>
References: <20090401174723.f0bea0eb.randy.dunlap@oracle.com>
Subject: [tip:timers/urgent] timers: add missing kernel-doc
Message-ID: <tip-633fe795b80693a8198e7d82f66538a72d2bbba2@git.kernel.org>
Git-Commit-ID: 633fe795b80693a8198e7d82f66538a72d2bbba2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 03:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  633fe795b80693a8198e7d82f66538a72d2bbba2
Gitweb:     http://git.kernel.org/tip/633fe795b80693a8198e7d82f66538a72d2bbba2
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Wed, 1 Apr 2009 17:47:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 05:54:00 +0200

timers: add missing kernel-doc

Add missing kernel-doc parameter notation and change function
name to its new name:

  Warning(kernel/timer.c:543): No description found for parameter 'name'
  Warning(kernel/timer.c:543): No description found for parameter 'key'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
LKML-Reference: <20090401174723.f0bea0eb.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/timer.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 9b77fc9..3af9a0b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -524,10 +524,13 @@ static void __init_timer(struct timer_list *timer)
 }
 
 /**
- * init_timer - initialize a timer.
+ * init_timer_key - initialize a timer
  * @timer: the timer to be initialized
+ * @name: name of the timer
+ * @key: lockdep class key of the fake lock used for tracking timer
+ *       sync lock dependencies
  *
- * init_timer() must be done to a timer prior calling *any* of the
+ * init_timer_key() must be done to a timer prior calling *any* of the
  * other timer functions.
  */
 void init_timer(struct timer_list *timer)
