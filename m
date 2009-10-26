Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZJZDZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZJZDZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 23:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZJZDZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 23:25:41 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:53255
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbZJZDZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 23:25:40 -0400
Subject: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.
From: Chen Liqin <liqin.chen@sunplusct.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       liqin.gnu@gmail.com
Content-Type: text/plain
Date: Mon, 26 Oct 2009 11:09:29 +0800
Message-Id: <1256526569.7283.3.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9741f7928ef35416e49f329a64e623a109de5c2d Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Mon, 26 Oct 2009 10:50:50 +0800
Subject: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.

Fixed __NR_ftruncate and __NR_ftruncate64 define in asm-generic/unistd.h.

Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 include/asm-generic/unistd.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index d76b66a..2869650 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -802,7 +802,7 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
 #define __NR_statfs __NR3264_statfs
 #define __NR_fstatfs __NR3264_fstatfs
 #define __NR_truncate __NR3264_truncate
-#define __NR_ftruncate __NR3264_truncate
+#define __NR_ftruncate __NR3264_ftruncate
 #define __NR_lseek __NR3264_lseek
 #define __NR_sendfile __NR3264_sendfile
 #define __NR_newfstatat __NR3264_fstatat
@@ -818,7 +818,7 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
 #define __NR_statfs64 __NR3264_statfs
 #define __NR_fstatfs64 __NR3264_fstatfs
 #define __NR_truncate64 __NR3264_truncate
-#define __NR_ftruncate64 __NR3264_truncate
+#define __NR_ftruncate64 __NR3264_ftruncate
 #define __NR_llseek __NR3264_lseek
 #define __NR_sendfile64 __NR3264_sendfile
 #define __NR_fstatat64 __NR3264_fstatat
-- 
1.6.2



