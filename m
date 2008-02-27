Return-Path: <linux-kernel-owner+w=401wt.eu-S1761748AbYB0VYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748AbYB0VYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbYB0VWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:22:16 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41787 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858AbYB0VWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:22:14 -0500
Date: Wed, 27 Feb 2008 23:21:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] crypto/digest.c should #include "internal.h"
Message-ID: <20080227212103.GQ29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global code (in this case for struct crypto_{init,exit}_digest_ops()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8680cc7b83fdcef7fbb84f9eac3f26f3d3e16b45 foobar
diff --git a/crypto/digest.c b/crypto/digest.c
index 6fd43bd..b526cc3 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -21,6 +21,8 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
+#include "internal.h"
+
 static int init(struct hash_desc *desc)
 {
 	struct crypto_tfm *tfm = crypto_hash_tfm(desc->tfm);

