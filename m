Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYFWCyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYFWCyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYFWCy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:54:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65373 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbYFWCy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:54:28 -0400
Message-ID: <485F0FFA.20900@cn.fujitsu.com>
Date: Mon, 23 Jun 2008 10:52:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockdep: remove duplicate definition of STATIC_LOCKDEP_MAP_INIT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STATIC_LOCKDEP_MAP_INIT is defined twice in lockdep.h. I guess
it's a copy & paste.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/lockdep.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4c4d236..f6279f6 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -276,14 +276,6 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 				 (lock)->dep_map.key, sub)
 
 /*
- * To initialize a lockdep_map statically use this macro.
- * Note that _name must not be NULL.
- */
-#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
-	{ .name = (_name), .key = (void *)(_key), }
-
-
-/*
  * Acquire a lock.
  *
  * Values for "read":
-- 
1.5.4.rc3
