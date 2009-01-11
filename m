Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZAKTgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZAKTgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZAKTg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:36:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZAKTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:36:25 -0500
Message-Id: <f27b8c356c4fab9ad222b45bc1cd1c750e64d97b.1231695451.git.kkeil@suse.de>
In-Reply-To: <cover.1231695451.git.kkeil@suse.de>
References: <cover.1231695451.git.kkeil@suse.de>
Subject: [PATCH 3/7] indentation & braces disagree - add braces
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
From: Karsten Keil <kkeil@suse.de>
Date: Sun, 11 Jan 2009 18:24:33 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@suse.de>,
       =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Date: Fri, 9 Jan 2009 12:22:50 -0800

Nothing is broken because of this - currently.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/isdn/mISDN/dsp_cmx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index 0ac67bf..b70c66b 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1893,7 +1893,7 @@ dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb)
 		/* in case of hardware (echo) */
 		if (dsp->pcm_slot_tx >= 0)
 			return;
-		if (dsp->echo)
+		if (dsp->echo) {
 			nskb = skb_clone(skb, GFP_ATOMIC);
 			if (nskb) {
 				hh = mISDN_HEAD_P(nskb);
@@ -1902,6 +1902,7 @@ dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb)
 				skb_queue_tail(&dsp->sendq, nskb);
 				schedule_work(&dsp->workq);
 			}
+		}
 		return;
 	}
 	/* in case of hardware conference */
-- 
1.5.6.4

