Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZH3USn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZH3USn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZH3USm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:18:42 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:32315 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbZH3USk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:18:40 -0400
Message-ID: <4A9ADEC0.70306@oracle.com>
Date: Sun, 30 Aug 2009 13:19:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] timer.h: drop a function prototype
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A9ADE8F.00F2:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Drop prototype for non-existent next_timer_interrupt() function.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timer.h |    5 -----
 1 file changed, 5 deletions(-)

--- lnx-2631-rc7.orig/include/linux/timer.h
+++ lnx-2631-rc7/include/linux/timer.h
@@ -175,11 +175,6 @@ extern int mod_timer_pinned(struct timer
 
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
