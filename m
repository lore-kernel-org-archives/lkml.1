Return-Path: <linux-kernel-owner+w=401wt.eu-S1161223AbXBUKDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161223AbXBUKDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161220AbXBUKDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:03:19 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:13194 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161209AbXBUKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:02:47 -0500
Date: Wed, 21 Feb 2007 11:02:47 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: holzheu@de.ibm.com
Subject: [S390] Remove BUG() statement
Message-ID: <20070221100247.GI13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

[S390] Remove BUG() statement

To avoid ugly warings for older gccs, we replace
BUG() with "return NULL", which is just as well.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/ipl.c linux-2.6-patched/arch/s390/kernel/ipl.c
--- linux-2.6/arch/s390/kernel/ipl.c	2007-02-21 10:47:32.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ipl.c	2007-02-21 10:47:32.000000000 +0100
@@ -91,7 +91,7 @@ static char *shutdown_action_str(enum sh
 	case SHUTDOWN_STOP:
 		return SHUTDOWN_STOP_STR;
 	default:
-		BUG();
+		return NULL;
 	}
 }
 
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

