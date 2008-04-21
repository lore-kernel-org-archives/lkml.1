Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYDUIst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYDUIst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYDUIsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:48:18 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58298 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbYDUIsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:48:17 -0400
Date: Mon, 21 Apr 2008 11:47:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] frv: remove HARD_RESET_NOW()
Message-ID: <20080421084749.GH26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HARD_RESET_NOW() was unused.

And one of the few remaining cli() users.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e2035c9bca6081c1ec8cea0215ba969ee30eddba diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
index 30a67a9..cb307f8 100644
--- a/include/asm-frv/system.h
+++ b/include/asm-frv/system.h
@@ -197,11 +197,6 @@ do {							\
 	do { var = (value); barrier(); } while (0)
 #endif
 
-#define HARD_RESET_NOW()			\
-do {						\
-	cli();					\
-} while(1)
-
 extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
 extern void free_initmem(void);
 

