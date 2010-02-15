Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0BOVuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:50:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:62409 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0BOVuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gxwyQIMMMhvs6uOYqWrQNPqs7qRNjte3ZoVPBqgfXbu16yRJtoWOYHWG+XAuGnlD1p
         qlILO5lu3ZQQEySL2NEf5ZrEEQF/jKMAT/EKX0vIbLTW/ge5YUmDzJ+3eO+TxXZ0DzSv
         XNbxCTdzjzqGLq4/Ef8YncEHoyviV3jOZ/azo=
Message-ID: <4B79C344.60908@gmail.com>
Date: Mon, 15 Feb 2010 22:57:24 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd: misplaced parenthesis in find_boot_record()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parenthesis was misplaced, upon error a one was shown.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/mtd/inftlmount.c b/drivers/mtd/inftlmount.c
index 32e82ae..a269c62 100644
--- a/drivers/mtd/inftlmount.c
+++ b/drivers/mtd/inftlmount.c
@@ -102,7 +102,7 @@ static int find_boot_record(struct INFTLrecord *inftl)
 		/* To be safer with BIOS, also use erase mark as discriminant */
 		if ((ret = inftl_read_oob(mtd, block * inftl->EraseSize +
 					  SECTORSIZE + 8, 8, &retlen,
-					  (char *)&h1) < 0)) {
+					  (char *)&h1)) < 0) {
 			printk(KERN_WARNING "INFTL: ANAND header found at "
 				"0x%x in mtd%d, but OOB data read failed "
 				"(err %d)\n", block * inftl->EraseSize,
