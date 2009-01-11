Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZAKTii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZAKTii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZAKTg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:36:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:39328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZAKTg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:36:26 -0500
Message-Id: <fae3e7fba4c664b3a15f2cf15ac439e8d754afc2.1231695451.git.kkeil@suse.de>
In-Reply-To: <cover.1231695451.git.kkeil@suse.de>
References: <cover.1231695451.git.kkeil@suse.de>
From: Karsten Keil <kkeil@suse.de>
Date: Sun, 11 Jan 2009 18:36:30 +0100
Subject: [PATCH 7/7] Fix small typo
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional ;

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/dsp_cmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index b70c66b..58c43e4 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1579,7 +1579,7 @@ send_packet:
 	schedule_work(&dsp->workq);
 }
 
-static u32	jittercount; /* counter for jitter check */;
+static u32	jittercount; /* counter for jitter check */
 struct timer_list dsp_spl_tl;
 u32	dsp_spl_jiffies; /* calculate the next time to fire */
 static u16	dsp_count; /* last sample count */
-- 
1.5.6.4

