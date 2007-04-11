Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXDKRwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXDKRwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXDKRwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:52:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:57461 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXDKRwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SfMi6fO0TO7mF3/k+kfdhJ7W4gVBLX2VMdbhnjZrHB2q7t1z7chf1FAwt0vL60asN7Zh3cpOzofAtjmxqjffBnVFvlueEVOHQMUEVyMzP5sdwal6pATtNjBo60pq8APovFMKXJzNGO/CUjmvvgEcfz4KAhoMWOY88SlUECcrQGE=
Date: Wed, 11 Apr 2007 23:24:34 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux1394-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, bcollins@debian.org,
       stefanr@s5r6.in-berlin.de
Subject: [KJ][PATCH]SPIN_LOCK_UNLOCKED cleanup in
Message-ID: <20070411175434.GA9110@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use DEFINE_SPINLOCK instead 

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
---

 ieee1394_transactions.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ieee1394/ieee1394_transactions.c b/drivers/ieee1394/ieee1394_transactions.c
index 0833fc9..8563077 100644
--- a/drivers/ieee1394/ieee1394_transactions.c
+++ b/drivers/ieee1394/ieee1394_transactions.c
@@ -32,7 +32,7 @@
 #ifndef HPSB_DEBUG_TLABELS
 static
 #endif
-spinlock_t hpsb_tlabel_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(hpsb_tlabel_lock);
 
 static DECLARE_WAIT_QUEUE_HEAD(tlabel_wq);
 
-- 
Milind Arun Choudhary
