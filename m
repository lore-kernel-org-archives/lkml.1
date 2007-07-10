Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbXGJJdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbXGJJdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763825AbXGJJ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:29:08 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:32125 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764149AbXGJJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:51 -0400
Message-Id: <20070710093122.774342855@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 14/16] cio: Remove prototype for non-existing function cmf_reset().
Content-Disposition: inline; filename=014-cio-rmfn.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/cmb.h |    1 -
 1 file changed, 1 deletion(-)

Index: quilt-2.6/include/asm-s390/cmb.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/cmb.h
+++ quilt-2.6/include/asm-s390/cmb.h
@@ -88,7 +88,6 @@ extern u64 cmf_read(struct ccw_device *c
  *    any
  **/
 extern int cmf_readall(struct ccw_device *cdev, struct cmbdata*data);
-extern void cmf_reset(struct ccw_device *cdev);
 
 #endif /* __KERNEL__ */
 #endif /* S390_CMB_H */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

