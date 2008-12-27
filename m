Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYL0Jx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYL0Jx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYL0Jxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:53:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42875 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYL0Jxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:53:49 -0500
Subject: [PATCH] x86_64: Eliminate atleast 10684 sparse warnings
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, randy.dunlap@oracle.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Dec 2008 15:21:36 +0530
Message-Id: <1230371496.3276.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid 10000+ sparse warnings

Eliminate 1434 sparse warnings like:
include/linux/list.h:106:16: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1434 sparse warnings like:
include/linux/list.h:107:16: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1434 sparse warnings like:
include/linux/list.h:579:12: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1434 sparse warnings like:
include/linux/list.h:580:13: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:97:16: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:143:14: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:260:13: warning: constant 0xdead000000000000 is so big it is unsigned long

Eliminate 1237 sparse warnings like:
include/linux/rculist.h:280:15: warning: constant 0xdead000000000000 is so big it is unsigned long

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/poison.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 603d3bd..f2de9a9 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -9,7 +9,7 @@
  * that is also not mappable by user-space exploits:
  */
 #ifdef CONFIG_ILLEGAL_POINTER_VALUE
-# define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
+# define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
 #else
 # define POISON_POINTER_DELTA 0
 #endif
-- 
1.5.5.1



