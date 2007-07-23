Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXGWI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXGWI5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760156AbXGWIyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:54:33 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:26908 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbXGWIyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:54:31 -0400
Message-Id: <20070723085714.929460242@de.ibm.com>
References: <20070723084548.394178614@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 10:45:56 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 8/9] add types.h include to s390_ext.h
Content-Disposition: inline; filename=008-s390-ext.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The header file for external interrupts uses the _u16 type. Make sure
that _u16 is defined by including linux/types.h. This prevents compile
failures, if asm/s390_ext.h is the first include file. 

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/s390_ext.h |    2 ++
 1 file changed, 2 insertions(+)

Index: quilt-2.6/include/asm-s390/s390_ext.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/s390_ext.h
+++ quilt-2.6/include/asm-s390/s390_ext.h
@@ -10,6 +10,8 @@
  *               Martin Schwidefsky (schwidefsky@de.ibm.com)
  */
 
+#include <linux/types.h>
+
 typedef void (*ext_int_handler_t)(__u16 code);
 
 /*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

