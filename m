Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbXGaSsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbXGaSsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763716AbXGaSsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:48:45 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1992 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469AbXGaSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:48:44 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 48] include/asm-mips/thread_info.h: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:48:41 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ralf@linux-mips.org, linux-mips@linux-mips.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312048.42172.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/asm-mips/thread_info.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/include/asm-mips/thread_info.h	2007-07-26 13:07:40.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/include/asm-mips/thread_info.h	2007-07-31 15:09:01.000000000 +0200
@@ -87,9 +87,8 @@ register struct thread_info *__current_t
 ({								\
 	struct thread_info *ret;				\
 								\
-	ret = kmalloc(THREAD_SIZE, GFP_KERNEL);			\
-	if (ret)						\
-		memset(ret, 0, THREAD_SIZE);			\
+	ret = kzalloc(THREAD_SIZE, GFP_KERNEL);			\
+								\
 	ret;							\
 })
 #else
