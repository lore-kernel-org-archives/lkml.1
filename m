Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYBYA0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYBYA0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbYBYAZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:25:36 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:6055 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbYBYAZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:25:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=frd81+uanRtL5nN8k26ByJlruBxxd26DJx1kwRO+3nrCYpUhxLypd0O1acxv1rg2V5UzJ4nlmTv6tjCox60LWzzM/YIu8xx/j9/3SCmaYW94XAcMIZBU+xxiWONpZ06q1Iip+AJg6f92pSAK5mtxqbzLfRLdCe2Lfk7FITe4Y4M=
Subject: [PATCH 5/6] block: remove extern on function definition
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
References: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 16:25:37 -0800
Message-Id: <1203899137.1767.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intoduced between 2.6.25-rc2 and -rc3
block/blk-settings.c:319:12: warning: function 'blk_queue_dma_drain' with external linkage has definition

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 block/blk-settings.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9a8ffdd..6200415 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * device can support otherwise there won't be room for the drain
  * buffer.
  */
-extern int blk_queue_dma_drain(struct request_queue *q,
+int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size)
 {
-- 
1.5.4.2.200.g99e75


