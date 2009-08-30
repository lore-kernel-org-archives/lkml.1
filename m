Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZH3U2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZH3U2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZH3U2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:28:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:48870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZH3U2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:28:31 -0400
Date: Sun, 30 Aug 2009 20:27:41 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, randy.dunlap@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, randy.dunlap@oracle.com
In-Reply-To: <4A9ADEC0.70306@oracle.com>
References: <4A9ADEC0.70306@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Drop a function prototype
Message-ID: <tip-e500011ffa191d662ac64d4ada6a5187b3180e16@git.kernel.org>
Git-Commit-ID: e500011ffa191d662ac64d4ada6a5187b3180e16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 30 Aug 2009 20:27:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e500011ffa191d662ac64d4ada6a5187b3180e16
Gitweb:     http://git.kernel.org/tip/e500011ffa191d662ac64d4ada6a5187b3180e16
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Sun, 30 Aug 2009 13:19:12 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 30 Aug 2009 22:26:34 +0200

timers: Drop a function prototype

Drop prototype for non-existent next_timer_interrupt() function.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm <akpm@linux-foundation.org>
LKML-Reference: <4A9ADEC0.70306@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 include/linux/timer.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index be62ec2..a2d1eb6 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -175,11 +175,6 @@ extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
 /*
  * Return when the next timer-wheel timeout occurs (in absolute jiffies),
- * locks the timer base:
- */
-extern unsigned long next_timer_interrupt(void);
-/*
- * Return when the next timer-wheel timeout occurs (in absolute jiffies),
  * locks the timer base and does the comparison against the given
  * jiffie.
  */
