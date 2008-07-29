Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYHBPPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYHBPPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYHBPPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:15:24 -0400
Received: from ns.suse.de ([195.135.220.2]:47559 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239AbYHBPPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:15:22 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
From: Karsten Keil <kkeil@suse.de>
Date: Tue, 29 Jul 2008 18:47:22 +0200
Subject: [PATCH 1/4] mISDN fix main ISDN Makefile
Message-Id: <20080802151520.D73A7A3C09@pingi.kke.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile hardware directory independent from selecting
CAPI support.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/Makefile b/drivers/isdn/Makefile
index 8380a45..f1f7775 100644
--- a/drivers/isdn/Makefile
+++ b/drivers/isdn/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_ISDN_I4L)			+= i4l/
 obj-$(CONFIG_ISDN_CAPI)			+= capi/
 obj-$(CONFIG_MISDN)			+= mISDN/
-obj-$(CONFIG_ISDN_CAPI)			+= hardware/
+obj-$(CONFIG_ISDN)			+= hardware/
 obj-$(CONFIG_ISDN_DIVERSION)		+= divert/
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax/
 obj-$(CONFIG_ISDN_DRV_ICN)		+= icn/
-- 
1.5.6.4

