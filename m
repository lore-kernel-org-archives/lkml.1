Return-Path: <linux-kernel-owner+w=401wt.eu-S1161482AbXDSJcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161482AbXDSJcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161484AbXDSJcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:32:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6576 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161482AbXDSJcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=j2dxyVeLS3K61wK4OXQR/uk8RL6igC+nGQMdek9MS394X2c4H0yR+//hjMoJpa5EY7iv1JqSqV1Hv14eyLb6t6LHJ+S7tWAeLFY73S6bFbWI52Euo+49Bk32HSV6832ZMmx+mYPny5TYvbca83+wlMyWLOuScWPQ9sYXvmRoTfQ=
Date: Thu, 19 Apr 2007 15:05:16 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>,
       MIPS <linux-mips@linux-mips.org>
Cc: Andrw Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, thomas.koeller@baslerweb.com,
       ralf@linux-mips.org
Subject: [KJ][PATCH]SPIN_LOCK_UNLOCKED cleanup in arch/mips
Message-ID: <20070419093516.GA9486@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use DEFINE_SPINLOCK instead 

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
---
 excite_setup.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/basler/excite/excite_setup.c b/arch/mips/basler/excite/excite_setup.c
index 42f0eda..2f0e4c0 100644
--- a/arch/mips/basler/excite/excite_setup.c
+++ b/arch/mips/basler/excite/excite_setup.c
@@ -63,7 +63,7 @@ volatile void __iomem * const ocd_base = (void *) (EXCITE_ADDR_OCD);
 volatile void __iomem * const titan_base = (void *) (EXCITE_ADDR_TITAN);
 
 /* Protect access to shared GPI registers */
-spinlock_t titan_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(titan_lock);
 int titan_irqflags;
 
 
-- 
Milind Arun Choudhary
