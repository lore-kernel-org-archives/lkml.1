Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbYFYOns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbYFYOns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbYFYOhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:37:10 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:29572 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445AbYFYOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:37:06 -0400
Message-Id: <20080625143614.189032014@de.ibm.com>
References: <20080625143459.100139455@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Jun 2008 16:35:10 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [patch 11/21] Cleanup cpacf printk messages.
Content-Disposition: inline; filename=810-printk-cpacf.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jang@linux.vnet.ibm.com>

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---

 arch/s390/crypto/prng.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: quilt-2.6/arch/s390/crypto/prng.c
===================================================================
--- quilt-2.6.orig/arch/s390/crypto/prng.c
+++ quilt-2.6/arch/s390/crypto/prng.c
@@ -185,11 +185,8 @@ static int __init prng_init(void)
 	prng_seed(16);
 
 	ret = misc_register(&prng_dev);
-	if (ret) {
-		printk(KERN_WARNING
-		       "Could not register misc device for PRNG.\n");
+	if (ret)
 		goto out_buf;
-	}
 	return 0;
 
 out_buf:

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

