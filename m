Return-Path: <linux-kernel-owner+w=401wt.eu-S936529AbYEBTHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936529AbYEBTHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964866AbYEBTFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:38960 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821AbYEBTFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iGBmrwaVt5Rc+HhHjpArZL3SJ+DvssuVEwaUWlhzhNLI9gb+lUju3HcghpjUZvDB2nyM/3f7dC1ERbXD+pKtD+yY3vGgDZDiNDqlokmebWrw/YezRlEK7FA2Q9X8ExLUbTPwXerI+oNS8VZAEow70Xo7EvrbYatqqVtb2/ufJdY=
Subject: [PATCH 01/14] block: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:54 -0700
Message-Id: <1209755154.26173.67.camel@brick>
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


