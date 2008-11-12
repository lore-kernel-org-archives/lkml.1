Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYKLMAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYKLMAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYKLMAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:00:21 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35828 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYKLMAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:00:20 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
       Holger Waechtler <holger@convergence.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ttusb-budget: make it depend on PCI
Date: Wed, 12 Nov 2008 07:00:18 -0500
Message-Id: <1226491218-9281-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since dvb-ttusb-budget.c relies on pci_alloc_consistent and
pci_free_consistent, make it depend on PCI in Kconfig.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/media/dvb/ttusb-budget/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ttusb-budget/Kconfig b/drivers/media/dvb/ttusb-budget/Kconfig
index f546bcc..2663ae3 100644
--- a/drivers/media/dvb/ttusb-budget/Kconfig
+++ b/drivers/media/dvb/ttusb-budget/Kconfig
@@ -1,6 +1,6 @@
 config DVB_TTUSB_BUDGET
 	tristate "Technotrend/Hauppauge Nova-USB devices"
-	depends on DVB_CORE && USB && I2C
+	depends on DVB_CORE && USB && I2C && PCI
 	select DVB_CX22700 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
 	select DVB_VES1820 if !DVB_FE_CUSTOMISE
-- 
1.6.0.3

