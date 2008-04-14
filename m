Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbYDNOYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbYDNOYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761555AbYDNOVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41957 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761160AbYDNOVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:03 -0400
Date: Mon, 14 Apr 2008 17:19:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd: proper prototypes for inftl_{read,write}_oob()
Message-ID: <20080414141958.GO6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper prototypes for inftl_{read,write}_oob() in 
include/linux/mtd/inftl.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mtd/inftlmount.c  |    5 -----
 include/linux/mtd/inftl.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

12972b4c2d014aa68e0293aef11b1c97e42a821d diff --git a/drivers/mtd/inftlmount.c b/drivers/mtd/inftlmount.c
index b8917be..c551d2f 100644
--- a/drivers/mtd/inftlmount.c
+++ b/drivers/mtd/inftlmount.c
@@ -41,11 +41,6 @@
 
 char inftlmountrev[]="$Revision: 1.18 $";
 
-extern int inftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
-			  size_t *retlen, uint8_t *buf);
-extern int inftl_write_oob(struct mtd_info *mtd, loff_t offs, size_t len,
-			   size_t *retlen, uint8_t *buf);
-
 /*
  * find_boot_record: Find the INFTL Media Header and its Spare copy which
  *	contains the various device information of the INFTL partition and
diff --git a/include/linux/mtd/inftl.h b/include/linux/mtd/inftl.h
index 6977780..85fd041 100644
--- a/include/linux/mtd/inftl.h
+++ b/include/linux/mtd/inftl.h
@@ -57,6 +57,11 @@ extern char inftlmountrev[];
 void INFTL_dumptables(struct INFTLrecord *s);
 void INFTL_dumpVUchains(struct INFTLrecord *s);
 
+int inftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
+		   size_t *retlen, uint8_t *buf);
+int inftl_write_oob(struct mtd_info *mtd, loff_t offs, size_t len,
+		    size_t *retlen, uint8_t *buf);
+
 #endif /* __KERNEL__ */
 
 #endif /* __MTD_INFTL_H__ */

