Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXJ2Tlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXJ2Tlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXJ2TjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:39:10 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42054 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXJ2TjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:39:08 -0400
To: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Message-Id: <6be0b56f72dac713943a5a3f63c993304f32d11a.1193686445.git.jeff@garzik.org>
In-Reply-To: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
References: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: [PATCH 08/16] [ISDN] HiSax: additional export to make things proper
Date: Mon, 29 Oct 2007 15:39:06 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/hscx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hisax/hscx.c b/drivers/isdn/hisax/hscx.c
index 09e1546..a01e961 100644
--- a/drivers/isdn/hisax/hscx.c
+++ b/drivers/isdn/hisax/hscx.c
@@ -277,6 +277,7 @@ inithscxisac(struct IsdnCardState *cs, int part)
 
 EXPORT_SYMBOL(HscxVersion);
 EXPORT_SYMBOL(inithscxisac);
+EXPORT_SYMBOL(inithscx);
 EXPORT_SYMBOL(clear_pending_hscx_ints);
 EXPORT_SYMBOL(hscx_l2l1);
 EXPORT_SYMBOL(open_hscxstate);
-- 
1.5.2.4

