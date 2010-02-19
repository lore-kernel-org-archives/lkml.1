Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0BSAWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:22:45 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44202 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0BSAWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wQbyWOzvaL2URtugNrxgWjylPhCwnY2GLMwfz33tYgGMklWczuuu6uV6ZyLdQFTsVC
         ltrPwurE9kNx1jRW8V3QqrNxSfbylAd2EO/rFyWmnM5vjjD3fILIX6FuU/Ik07NkkfYY
         rPlRdHT3fyVoygMnE4QFho3SrfGdg1hwAa2dc=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/19] crypto: seqiv - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:22 +0100
Message-Id: <1266538943-3344-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/seqiv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 5a013a8..ba79b09 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -116,7 +116,7 @@ static int seqiv_givencrypt(struct skcipher_givcrypt_request *req)
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_ablkcipher_alignmask(geniv) + 1))) {
 		info = kmalloc(ivsize, req->creq.base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 								  GFP_ATOMIC);
 		if (!info)
 			return -ENOMEM;
@@ -162,7 +162,7 @@ static int seqiv_aead_givencrypt(struct aead_givcrypt_request *req)
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_aead_alignmask(geniv) + 1))) {
 		info = kmalloc(ivsize, areq->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 								  GFP_ATOMIC);
 		if (!info)
 			return -ENOMEM;
-- 
1.6.6.1

