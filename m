Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYKSNRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYKSNRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYKSNQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:16:30 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:52375 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYKSNQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=hiyZerYPbjVjStUzLfCb8ILmb35/0SbrIPhhLqbQCBPQYQB+rUhybcW//v1HqJnA5v
         /X+5C550WJ57ao5CGrsxt75rWMhM1EB4A0NNWiuh5PqbOxhBIQrf1KkryI5aomk+HHGF
         rnJ3oOaOlaWz5XOiCGIJyso99BsE8ZliwGDN8=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>,
       Mike Lavender <mike@steroidmicros.com>,
       David Hinds <dahinds@users.sourceforge.net>
Subject: [PATCH 2/4] drivers/mtd/nand/cmx270_nand.c: mark {__init|__exit} for
 {init|exit} functions
Date: Wed, 19 Nov 2008 21:16:22 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492411ac.0c486e0a.3215.0294@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/mtd/nand/cmx270_nand.c b/drivers/mtd/nand/cmx270_nand.c
index fa129c0..c429ea2 100644
--- a/drivers/mtd/nand/cmx270_nand.c
+++ b/drivers/mtd/nand/cmx270_nand.c
@@ -148,7 +148,7 @@ static int cmx270_device_ready(struct mtd_info *mtd)
 /*
  * Main initialization routine
  */
-static int cmx270_init(void)
+static int __init cmx270_init(void)
 {
 	struct nand_chip *this;
 	const char *part_type;
@@ -262,7 +262,7 @@ module_init(cmx270_init);
 /*
  * Clean up routine
  */
-static void cmx270_cleanup(void)
+static void __exit cmx270_cleanup(void)
 {
 	/* Release resources, unregister device */
 	nand_release(cmx270_nand_mtd);

