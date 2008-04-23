Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYDWKCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYDWKCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYDWJx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:29 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59532 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbYDWJx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:28 -0400
Date: Wed, 23 Apr 2008 12:52:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport blk_max_pfn
Message-ID: <20080423095248.GO28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_max_pfn can now be unexported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
cb4bf25adc9782eebb03eceeca9aa14a10ccfaa9 diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5713f7e..77b51dc 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -14,7 +14,6 @@ unsigned long blk_max_low_pfn;
 EXPORT_SYMBOL(blk_max_low_pfn);
 
 unsigned long blk_max_pfn;
-EXPORT_SYMBOL(blk_max_pfn);
 
 /**
  * blk_queue_prep_rq - set a prepare_request function for queue

