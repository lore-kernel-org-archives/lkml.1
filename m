Return-Path: <linux-kernel-owner+w=401wt.eu-S937020AbXLTPna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937020AbXLTPna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934240AbXLTPWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:49 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:6694 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbXLTPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:08 -0500
Message-Id: <20071220152106.252234639@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:40 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Ursula Braun <braunu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 15/47] qdio: set QDIO_ACTIVATE_TIMEOUT to 5s
Content-Disposition: inline; filename=114-qdio-timeout.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ursula Braun <braunu@de.ibm.com>

Current definition of QDIO_ACTIVATE_TIMEOUT results in value 0.
Thus it may cause endless wait in function qdio_activate().

Signed-off-by: Ursula Braun <braunu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/qdio.h
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio.h
+++ quilt-2.6/drivers/s390/cio/qdio.h
@@ -57,7 +57,7 @@
 					    of the queue to 0 */
 
 #define QDIO_ESTABLISH_TIMEOUT (1*HZ)
-#define QDIO_ACTIVATE_TIMEOUT ((5*HZ)>>10)
+#define QDIO_ACTIVATE_TIMEOUT (5*HZ)
 #define QDIO_CLEANUP_CLEAR_TIMEOUT (20*HZ)
 #define QDIO_CLEANUP_HALT_TIMEOUT (10*HZ)
 #define QDIO_FORCE_CHECK_TIMEOUT (10*HZ)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

