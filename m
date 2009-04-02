Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbZDBAtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbZDBAtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759943AbZDBAsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:48:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:54448 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760834AbZDBAsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:48:52 -0400
Date: Wed, 1 Apr 2009 17:47:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] timers: add missing kernel-doc
Message-Id: <20090401174723.f0bea0eb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49D40B20.0093:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc parameter notation and change function
name to its new name:

Warning(kernel/timer.c:543): No description found for parameter 'name'
Warning(kernel/timer.c:543): No description found for parameter 'key'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Johannes Berg <johannes@sipsolutions.net>
---
 kernel/timer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.29-git8.orig/kernel/timer.c
+++ linux-2.6.29-git8/kernel/timer.c
@@ -531,10 +531,13 @@ static void __init_timer(struct timer_li
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
 void init_timer_key(struct timer_list *timer,
