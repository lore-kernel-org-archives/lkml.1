Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZHaDsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZHaDsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 23:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZHaDsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 23:48:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:59975 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZHaDsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 23:48:31 -0400
Subject: [PATCH] lmb: Also remove __init from lmb_end_of_RAM() declaration
 in lmb.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 13:48:16 +1000
Message-Id: <1251690496.9499.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch removed __init in lmb.c but missed the fact
that it was also marked as such in the .h

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

And this one I tested :-)

Cheers,
Ben.

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index c46c895..2442e3f 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -51,7 +51,7 @@ extern u64 __init lmb_alloc_base(u64 size,
 extern u64 __init __lmb_alloc_base(u64 size,
 		u64 align, u64 max_addr);
 extern u64 __init lmb_phys_mem_size(void);
-extern u64 __init lmb_end_of_DRAM(void);
+extern u64 lmb_end_of_DRAM(void);
 extern void __init lmb_enforce_memory_limit(u64 memory_limit);
 extern int __init lmb_is_reserved(u64 addr);
 extern int lmb_find(struct lmb_property *res);



