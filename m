Return-Path: <linux-kernel-owner+w=401wt.eu-S938664AbXHLWYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938664AbXHLWYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 18:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbXHLWYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 18:24:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:43393 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765462AbXHLWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 18:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HfX+LTNMlyYYT3xE9sYqvvMeucYSR49NAHZQXyM9wY+PuSEGrq0sOdItkquJdHDBakBLnZzsnDYKIm+cQee76Z0rsZinGJG9jLD8VUlb2sNuRzjgUzYWylofywhMCvW/IUcJESRN6VGkGhufVKsBsFzWC6V3HvlnVmbdSAcow8E=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/6][RESEND] fix tiny spelling error in comment in cfi_cmdset_0001.c
Date: Mon, 13 Aug 2007 00:21:56 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, Jesper Juhl <jesper.juhl@gmail.com>
References: <200708130016.11281.jesper.juhl@gmail.com>
In-Reply-To: <200708130016.11281.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130021.56454.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(previously send on 05-Jul-2007 02:18, 04-Aug-2007 20:31)

Trivial fix of a spelling error in a comment in cfi_cmdset_0001.c
s/ships/chips/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 2f19fa7..c266ebc 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -526,7 +526,7 @@ static int cfi_intelext_partition_fixup(struct mtd_info *mtd,
 	struct cfi_pri_intelext *extp = cfi->cmdset_priv;
 
 	/*
-	 * Probing of multi-partition flash ships.
+	 * Probing of multi-partition flash chips.
 	 *
 	 * To support multiple partitions when available, we simply arrange
 	 * for each of them to have their own flchip structure even if they
