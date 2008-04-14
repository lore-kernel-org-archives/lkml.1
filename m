Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbYDNOWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbYDNOWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761073AbYDNOUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:20:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41356 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761502AbYDNOUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:20:51 -0400
Date: Mon, 14 Apr 2008 17:19:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd/ofpart.c: add MODULE_LICENSE
Message-ID: <20080414141946.GM6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b530cd2188d467f2b157e77349baa8e854b61a17 diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index f86e069..4f80c2f 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -72,3 +72,5 @@ int __devinit of_mtd_parse_partitions(struct device *dev,
 	return nr_parts;
 }
 EXPORT_SYMBOL(of_mtd_parse_partitions);
+
+MODULE_LICENSE("GPL");

