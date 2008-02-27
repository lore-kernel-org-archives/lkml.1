Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYB0QaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYB0QaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYB0Q3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:29:54 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:51319 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYB0Q3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:29:53 -0500
Date: Wed, 27 Feb 2008 17:29:10 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mikael.starvik@axis.com, jesper.nilsson@axis.se
Subject: [PATCH] CRIS: Correct syscall numbers in unistd.h for timerfd_settime and timerfd_gettime
Message-ID: <20080227162910.GC1644@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last commit for unistd was not correct, it only had a partial update
of syscall numbers for __NR_timerfd_settime and __NR_timerfd_gettime.
Also, NR_syscalls was not incremented for the new syscalls.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/unistd.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-cris/unistd.h b/include/asm-cris/unistd.h
index 007cb16..76398ef 100644
--- a/include/asm-cris/unistd.h
+++ b/include/asm-cris/unistd.h
@@ -329,12 +329,12 @@
 #define __NR_timerfd_create	322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
-#define __NR_timerfd_settime    315
-#define __NR_timerfd_gettime    316
+#define __NR_timerfd_settime	325
+#define __NR_timerfd_gettime	326
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 327
 
 #include <asm/arch/unistd.h>
 
-- 
1.5.3.6.970.gd25430


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
