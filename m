Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYFOQOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYFOQOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbYFOQOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:14:35 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60777 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255AbYFOQOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:14:34 -0400
Date: Sun, 15 Jun 2008 19:13:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080615161316.GA7865@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4cec562181f818f16f072b9a14ca7a0ce6c66417 diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index fdc36bf..6d3bebb 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -308,3 +308,5 @@ static void __exit exit_som_binfmt(void)
 
 core_initcall(init_som_binfmt);
 module_exit(exit_som_binfmt);
+
+MODULE_LICENSE("GPL");
