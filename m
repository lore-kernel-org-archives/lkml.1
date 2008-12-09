Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYLJQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYLJQQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbYLJQNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:13:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:61502 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYLJQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:13:51 -0500
Message-ID: <493feabd.0c11660a.1e2c.4f26@mx.google.com>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Tue, 9 Dec 2008 21:52:14 +0100
Subject: [PATCH 7/9] mISDN: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: comment out unused symbols

Fix this sparse warnings:

  drivers/isdn/hardware/mISDN/hfcmulti.c:794: warning: 'vpm_check' defined but not used
  drivers/isdn/mISDN/dsp_cmx.c:1546: warning: 'dsp_start_jiffies' defined but not used

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    2 ++
 drivers/isdn/mISDN/dsp_cmx.c           |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index b4595f7..2b0e5db 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -789,6 +789,7 @@ vpm_init(struct hfc_multi *wc)
 	}
 }
 
+#ifdef UNUSED
 static void
 vpm_check(struct hfc_multi *hctmp)
 {
@@ -799,6 +800,7 @@ vpm_check(struct hfc_multi *hctmp)
 	if ((gpi2 & 0x3) != 0x3)
 		printk(KERN_DEBUG "Got interrupt 0x%x from VPM!\n", gpi2);
 }
+#endif /* UNUSED */
 
 
 /*
diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index e868c47..c884511 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1543,7 +1543,9 @@ send_packet:
 static u32	samplecount;
 struct timer_list dsp_spl_tl;
 u32	dsp_spl_jiffies; /* calculate the next time to fire */
+#ifdef UNUSED
 static u32	dsp_start_jiffies; /* jiffies at the time, the calculation begins */
+#endif /* UNUSED */
 static struct timeval dsp_start_tv; /* time at start of calculation */
 
 void
-- 
1.5.6.3

