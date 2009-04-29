Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZD2OBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZD2OBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZD2OBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:01:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50411 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZD2OBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:01:04 -0400
Message-ID: <49F85D9C.4000405@redhat.com>
Date: Wed, 29 Apr 2009 16:01:00 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] block: remove unused __REQ_NR_BITS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removes __REQ_NR_BITS which is not used since its only user
(blk_dump_rq_flags()) stopped to use it.


Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2755d5c..a101821 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -119,7 +119,6 @@ enum rq_flag_bits {
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
 	__REQ_IO_STAT,		/* account I/O stat */
-	__REQ_NR_BITS,		/* stops here */
 };
 
 #define REQ_RW		(1 << __REQ_RW)


