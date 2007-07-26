Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbXGZQiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbXGZQiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934380AbXGZQel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:34:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35514 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934438AbXGZQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:34:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] alpha: long constant
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6IR-0005Ip-M7@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:34:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-alpha/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-alpha/bitops.h b/include/asm-alpha/bitops.h
index 3a0cbeb..9e71201 100644
--- a/include/asm-alpha/bitops.h
+++ b/include/asm-alpha/bitops.h
@@ -324,7 +324,7 @@ static inline int fls64(unsigned long x)
 {
 	unsigned long t, a, r;
 
-	t = __kernel_cmpbge (x, 0x0101010101010101);
+	t = __kernel_cmpbge (x, 0x0101010101010101UL);
 	a = __flsm1_tab[t];
 	t = __kernel_extbl (x, a);
 	r = a*8 + __flsm1_tab[t] + (x != 0);
-- 
1.5.3.GIT


