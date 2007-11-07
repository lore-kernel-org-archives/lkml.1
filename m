Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXKGOWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXKGOWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbXKGOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:47 -0500
Received: from il.qumranet.com ([82.166.9.18]:50648 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860AbXKGOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:42 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 8/8] KVM: Update drivers/Makefile to check for CONFIG_VIRTUALIZATION
Date: Wed,  7 Nov 2007 16:21:09 +0200
Message-Id: <11944452691057-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11944452693579-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <11944452691714-git-send-email-amit.shah@qumranet.com>
 <11944452692774-git-send-email-amit.shah@qumranet.com>
 <11944452694052-git-send-email-amit.shah@qumranet.com>
 <1194445269859-git-send-email-amit.shah@qumranet.com>
 <1194445269469-git-send-email-amit.shah@qumranet.com>
 <11944452693466-git-send-email-amit.shah@qumranet.com>
 <11944452693579-git-send-email-amit.shah@qumranet.com>
Message-Id: <fbc5dea9bfdb021ab2d3808583314901799405a0.1194445109.git.amit.shah@qumranet.com>
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Check for CONFIG_VIRTUALIZATION instead of CONFIG_KVM,
since the PV drivers won't depend on CONFIG_KVM and we
still want to be selectable

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 drivers/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 8cb37e3..6f1c287 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_SPI)		+= spi/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
 obj-$(CONFIG_DIO)		+= dio/
 obj-$(CONFIG_SBUS)		+= sbus/
-obj-$(CONFIG_KVM)		+= kvm/
+obj-$(CONFIG_VIRTUALIZATION)	+= kvm/
 obj-$(CONFIG_ZORRO)		+= zorro/
 obj-$(CONFIG_MAC)		+= macintosh/
 obj-$(CONFIG_ATA_OVER_ETH)	+= block/aoe/
-- 
1.5.3

