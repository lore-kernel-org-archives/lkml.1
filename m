Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZFDSgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZFDSgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZFDSgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:36:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbZFDSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:36:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oxMUIUoUpInxpbQCUGDHTBmPj7IL1yAkEUq0YysBzu3cLtMlQmaK39GpCingZ/AqXw
         ftmRkJvFiSqKFysPYrhezv9174UNrwumVv63CQ8z4Zs6pAttNgg+fzTcYhpxPYu2C5AI
         E5CpnLoy4+iFILtu4vp2AVAuXHPkw+BUETD5E=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/7] MFD: ASIC3: add ASIC3 IRQ numbers
Date: Thu,  4 Jun 2009 20:36:12 +0200
Message-Id: <1244140576-18006-4-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ number definitions for PWM, LED, SPI and OWM (ds1wm).

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 include/linux/mfd/asic3.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index cd02d20..5fc3aa4 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -33,6 +33,13 @@ struct asic3_platform_data {
 #define ASIC3_NUM_GPIOS		64
 #define ASIC3_NR_IRQS		ASIC3_NUM_GPIOS + 6
 
+#define ASIC3_IRQ_LED0		64
+#define ASIC3_IRQ_LED1		65
+#define ASIC3_IRQ_LED2		66
+#define ASIC3_IRQ_SPI		67
+#define ASIC3_IRQ_SMBUS		68
+#define ASIC3_IRQ_OWM		69
+
 #define ASIC3_TO_GPIO(gpio) (NR_BUILTIN_GPIO + (gpio))
 
 #define ASIC3_GPIO_BANK_A	0
-- 
1.6.3.1

