Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYAHIz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYAHIz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbYAHIzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:55:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:5677 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbYAHIzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:55:13 -0500
Date: Tue, 8 Jan 2008 11:44:34 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: [PATCH -mm 2/4] hifn_795x: fixup container_of() usage
Message-ID: <20080108084434.GB6209@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH -mm 2/4] hifn_795x: fixup container_of() usage

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/crypto/hifn_795x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -664,7 +664,7 @@ struct hifn_context
 	atomic_t		sg_num;
 };
 
-#define crypto_alg_to_hifn(alg)	container_of(alg, struct hifn_crypto_alg, alg)
+#define crypto_alg_to_hifn(a)	container_of(a, struct hifn_crypto_alg, alg)
 
 static inline u32 hifn_read_0(struct hifn_device *dev, u32 reg)
 {

