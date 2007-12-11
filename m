Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbXLKWUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbXLKWUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXLKWTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:19:51 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54601 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752728AbXLKWTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:19:49 -0500
Date: Tue, 11 Dec 2007 23:19:50 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jordan Crouse <jordan.crouse@amd.com>, herbert@gondor.apana.org.au,
       davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] crypto/geode-aes.c: add __dev{init,exit} annotations
Message-ID: <20071211221949.GB14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds __dev{init,exit} annotations.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/crypto/geode-aes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

9a5ecd183293da27ad66241b51c93bea0634df55 
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 711e246..96deb47 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -374,7 +374,7 @@ static struct crypto_alg geode_ecb_alg = {
 	}
 };
 
-static void
+static void __devexit
 geode_aes_remove(struct pci_dev *dev)
 {
 	crypto_unregister_alg(&geode_alg);
@@ -389,7 +389,7 @@ geode_aes_remove(struct pci_dev *dev)
 }
 
 
-static int
+static int __devinit
 geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int ret;

