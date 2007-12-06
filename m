Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbXLFQOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbXLFQOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXLFQON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:14:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:16805 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbXLFQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:14:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lh6HVaU5ZQo5Lz4oiK1eaiGV15WzMFk2Uo3M/cbxG8KJEALPgakq9eXPh1L9cVtZJreC5tG88sM/nfCvAzWsTkVxH7iMQJNulKxadQAAXVnYL9QJ2zg5NTHPZ44EUKctXlyjetICE5lkZaNm5qmaTX2Z37y/piN/dQ+g9iSf7OE=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/20] drivers/dma/iop-adma.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:13:24 +0800
Message-Id: <1196957605-5797-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1196957605-5797-1-git-send-email-crquan@gmail.com>
References: <
 <1196957605-5797-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these three list_head are all local variables, but can also use LIST_HEAD.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/dma/iop-adma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index e5c62b7..b011b5a 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -284,7 +284,7 @@ iop_adma_alloc_slots(struct iop_adma_chan *iop_chan, int num_slots,
 			int slots_per_op)
 {
 	struct iop_adma_desc_slot *iter, *_iter, *alloc_start = NULL;
-	struct list_head chain = LIST_HEAD_INIT(chain);
+	LIST_HEAD(chain);
 	int slots_found, retry = 0;
 
 	/* start search from the last allocated descrtiptor
-- 
1.5.3.4

