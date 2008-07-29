Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYG2TvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYG2TvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYG2TvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:51:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:49761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbYG2TvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:51:13 -0400
Date: Tue, 29 Jul 2008 21:51:11 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mISDN fix main ISDN Makefile
Message-ID: <20080729195111.GA25929@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master

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


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
