Return-Path: <linux-kernel-owner+w=401wt.eu-S934693AbZLPIKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbZLPIKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761752AbZLPIJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:09:18 -0500
Received: from mail.perches.com ([173.55.12.10]:1199 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761737AbZLPIJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:15 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] kernel.h: ARRAY_SIZE neatening
Date: Wed, 16 Dec 2009 00:09:02 -0800
Message-Id: <5269eef3dc95981d5a8698b7fb6d03bed8d61a08.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make < 80 column, use array as name

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2cc6d70..9206268 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -39,7 +39,8 @@
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
 
-#define ARRAY_SIZE(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define ARRAY_SIZE(array)	(sizeof(array) / sizeof((array)[0]) +	\
+				 __must_be_array(array))
 #define FIELD_SIZEOF(t, f)	(sizeof(((t *)0)->f))
 
 #define roundup(x, y)		((((x) + ((y) - 1)) / (y)) * (y))
-- 
1.6.6.rc0.57.gad7a

