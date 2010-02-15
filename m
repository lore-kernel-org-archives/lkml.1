Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0BOVyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:54:20 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:63512 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab0BOVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X7r56YKABklTlW3bHoGM2OZL/TLFoCiBvuTHASCC4VUVkCRgLlw3fRzpqbdjxBPJeN
         R+pRWE98zgPtj+jFrqce8L7qycfOtqAIidpgsq/Aj/SYhJ6kWuWuVCeoM2+mVOQKTIt8
         ibT4T5pJIOaOluqmgDLmaHThdkmK5ZhLTaSEs=
Message-ID: <4B79C444.8090402@gmail.com>
Date: Mon, 15 Feb 2010 23:01:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: misplaced parenthesis in find_boot_record()
References: <4B79C344.60908@gmail.com>
In-Reply-To: <4B79C344.60908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parenthesis was misplaced

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Not sure if you care about this one, it is between #if 0 ... #endif 

diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
index 8b22b18..1ae6a02 100644
--- a/drivers/mtd/nftlmount.c
+++ b/drivers/mtd/nftlmount.c
@@ -109,7 +109,7 @@ static int find_boot_record(struct NFTLrecord *nftl)
 
 		/* Finally reread to check ECC */
 		if ((ret = mtd->read(mtd, block * nftl->EraseSize, SECTORSIZE,
-				     &retlen, buf) < 0)) {
+				     &retlen, buf)) < 0) {
 			printk(KERN_NOTICE "ANAND header found at 0x%x in mtd%d, but ECC read failed (err %d)\n",
 			       block * nftl->EraseSize, nftl->mbd.mtd->index, ret);
 			continue;
