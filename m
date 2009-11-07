Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZKGRnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZKGRnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 12:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZKGRnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 12:43:08 -0500
Received: from mba.ocn.ne.jp ([122.28.14.163]:52025 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZKGRnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 12:43:07 -0500
Date: Sun, 08 Nov 2009 02:43:07 +0900 (JST)
Message-Id: <20091108.024307.183026733.anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, Mike Frysinger <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH resend] mtd/maps: Fix accidental removal in Makefile
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit d79c326 ("gpio-addr-flash: new driver for GPIO assisted
flash addressing") removed two lines from the Makefile by accident.
Though I'm not sure how this accident happened, this patch reverts the
removal.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This patch fixes a regression from 2.6.31

 drivers/mtd/maps/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 1d5cf86..ae2f6db 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -58,4 +58,6 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
 obj-$(CONFIG_MTD_BFIN_ASYNC)	+= bfin-async-flash.o
+obj-$(CONFIG_MTD_RBTX4939)	+= rbtx4939-flash.o
+obj-$(CONFIG_MTD_VMU)		+= vmu-flash.o
 obj-$(CONFIG_MTD_GPIO_ADDR)	+= gpio-addr-flash.o
-- 
1.5.6.5
