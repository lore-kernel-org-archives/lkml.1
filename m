Return-Path: <linux-kernel-owner+w=401wt.eu-S1161199AbXBUKAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161199AbXBUKAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161198AbXBUKAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:00:54 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:65404 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161194AbXBUKAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:00:42 -0500
Date: Wed, 21 Feb 2007 11:00:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: jan.glauber@de.ibm.com
Subject: [S390] fix non-smp compile.
Message-ID: <20070221100042.GC13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jan.glauber@de.ibm.com>

[S390] fix non-smp compile.

Fix compile of sclp_quiesce for CONFIG_SMP=n.

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

---

 drivers/s390/char/sclp_quiesce.c |    1 +
 1 files changed, 1 insertion(+)

diff -urpN linux-2.6/drivers/s390/char/sclp_quiesce.c linux-2.6-patched/drivers/s390/char/sclp_quiesce.c
--- linux-2.6/drivers/s390/char/sclp_quiesce.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_quiesce.c	2007-02-21 10:47:24.000000000 +0100
@@ -16,6 +16,7 @@
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/sigp.h>
+#include <asm/smp.h>
 
 #include "sclp.h"
 
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

