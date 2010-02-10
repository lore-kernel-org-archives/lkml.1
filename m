Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0BJAu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:50:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53659 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0BJAuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:50:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HKIj5iCX/8Zq3pi0Ksoi+6wDztiEraaAkt+s5MTSCAFOfk/QUq71NeaHvkqEfKFSot
         d4ZHvmyo/CGu3AmpUN9Z3U6XS+eKEZLyHU2xYMxCGkQgYCZSdjzvsB/OTI9J2uS4tbJY
         bj+p6sUAS8YsgNCiAB4DvzH9KurdEjrVQoL5o=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Brad Bosch <bradbosch@comcast.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in algapi.c
Date: Wed, 10 Feb 2010 01:49:58 +0100
Message-Id: <1265762999-22112-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/algapi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f149b1c..3e4524e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -230,7 +230,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &crypto_alg_list);
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
-out:	
+out:
 	return larval;
 
 free_larval:
@@ -388,7 +388,7 @@ int crypto_unregister_alg(struct crypto_alg *alg)
 {
 	int ret;
 	LIST_HEAD(list);
-	
+
 	down_write(&crypto_alg_sem);
 	ret = crypto_remove_alg(alg, &list);
 	up_write(&crypto_alg_sem);
-- 
1.6.6.1

