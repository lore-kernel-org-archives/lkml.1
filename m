Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbYC2DJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbYC2DJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbYC2DIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:08:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49823 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYC2DIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:08:19 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] NULL noise: frv cmpxchg()
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Message-Id: <E1JfRQY-0002dr-JG@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:08:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-frv/system.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
index b400cea..2c57f47 100644
--- a/include/asm-frv/system.h
+++ b/include/asm-frv/system.h
@@ -234,7 +234,7 @@ extern void free_initmem(void);
 		break;								\
 										\
 	default:								\
-		__xg_orig = 0;							\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
 		asm volatile("break");						\
 		break;								\
 	}									\
@@ -259,7 +259,7 @@ extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
 					 (__force uint32_t)__xg_test,		\
 					 (__force uint32_t)__xg_new); break;	\
 	default:								\
-		__xg_orig = 0;							\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
 		asm volatile("break");						\
 		break;								\
 	}									\
-- 
1.5.3.GIT


