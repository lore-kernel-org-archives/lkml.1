Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbXJDLcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbXJDLcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbXJDL2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:28:48 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:53243 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbXJDL20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:26 -0400
Message-Id: <20071004112828.407925488@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 14/34] zcrypt: make init/exit functions static.
Content-Disposition: inline; filename=014-zcrypt-static.diff
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

