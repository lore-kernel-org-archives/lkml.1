Return-Path: <linux-kernel-owner+w=401wt.eu-S934267AbXHGLWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267AbXHGLWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763106AbXHGLPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:15:53 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:29782 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982AbXHGLPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:15:12 -0400
Message-Id: <20070807111848.751369939@de.ibm.com>
References: <20070807111519.972871123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Aug 2007 13:15:37 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 17/18] zcrypt: make init/exit functions static.
Content-Disposition: inline; filename=106-zcrypt-static.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/crypto/zcrypt_mono.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/crypto/zcrypt_mono.c
===================================================================
--- quilt-2.6.orig/drivers/s390/crypto/zcrypt_mono.c
+++ quilt-2.6/drivers/s390/crypto/zcrypt_mono.c
@@ -45,7 +45,7 @@
 /**
  * The module initialization code.
  */
-int __init zcrypt_init(void)
+static int __init zcrypt_init(void)
 {
 	int rc;
 
@@ -86,7 +86,7 @@ out:
 /**
  * The module termination code.
  */
-void __exit zcrypt_exit(void)
+static void __exit zcrypt_exit(void)
 {
 	zcrypt_cex2a_exit();
 	zcrypt_pcixcc_exit();

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

