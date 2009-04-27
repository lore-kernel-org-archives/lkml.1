Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZD0Lh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZD0Lh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZD0Lht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:37:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZD0Lhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:37:48 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Cleanup: Remove unused __REQ_NR_BITS from enum rq_flag_bits
Date: Mon, 27 Apr 2009 17:05:30 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271705.30550.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __REQ_NR_BITS  was being used by blk_dump_rq_flags() long back, while 
printing the individual request flag bits as strings to limit to the used 
bits. But it does not use it now. Remove unused enum.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba54c83..f41abbb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -118,7 +118,6 @@ enum rq_flag_bits {
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
-	__REQ_NR_BITS,		/* stops here */
 };
 
 #define REQ_RW		(1 << __REQ_RW)

