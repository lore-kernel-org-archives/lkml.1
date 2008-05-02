Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbYEBDxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbYEBDxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYEBDwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48822 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbYEBDwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jKg5p2NMJMp3R05z86S0SNge8wZQ/FTk7cVlCbPkHs60Se05mdyRyknj9q6v6eS52Zv6dsGzq9uZDwQ18vk7UCk+L6AyHF0T9Amb3pnF0C1+6F4LXLwMphGXigpk3f15alE2wfIfXnELx7DT8NxqNkGF0ExDlTwC1Xf3TO227pw=
Subject: [PATCH 1/8] block: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:55 -0700
Message-Id: <1209700375.22362.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/block/aoe/aoecmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 8fc429c..fdde6ad 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1001,7 +1001,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	 * Enough people have their dip switches set backwards to
 	 * warrant a loud message for this special case.
 	 */
-	aoemajor = be16_to_cpu(get_unaligned(&h->major));
+	aoemajor = get_unaligned_be16(&h->major);
 	if (aoemajor == 0xfff) {
 		printk(KERN_ERR "aoe: Warning: shelf address is all ones.  "
 			"Check shelf dip switches.\n");
-- 
1.5.5.1.350.gbbbf


