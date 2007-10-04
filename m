Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXJDLje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXJDLje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbXJDL3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:29:18 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:25477 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbXJDL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:30 -0400
Message-Id: <20071004112831.765609656@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Ursula Braun <braunu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 26/34] qdio: change QDIO performance_stats error message priority
Content-Disposition: inline; filename=026-qdio-message.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ursula Braun <braunu@de.ibm.com>

Signed-off-by: Ursula Braun <braunu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/cio/qdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/qdio.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio.c
+++ quilt-2.6/drivers/s390/cio/qdio.c
@@ -3727,7 +3727,7 @@ qdio_performance_stats_store(struct bus_
 #endif /* CONFIG_64BIT */
 		}
 	} else {
-		QDIO_PRINT_WARN("QDIO performance_stats: write 0 or 1 to this file!\n");
+		QDIO_PRINT_ERR("QDIO performance_stats: write 0 or 1 to this file!\n");
 		return -EINVAL;
 	}
 	return count;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

