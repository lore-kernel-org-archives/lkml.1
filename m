Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZFEQbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZFEQbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZFEQax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:30:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21695 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbZFEQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fdt5t2wTWXIhwLMyHjieQPD5V0gC813FLBidN140Wtw8fFik1C3vHAIIrwgCDYbT7m
         tt+oUru3CZSfRqSgN4bVrR/EgZtPlJ+21CyPG7Z9Nhhp5K0DsG3/k84+X5qwNYn2aUPT
         y+248ZckW97r90CfAyKktRtytSGczNKlEwKBw=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/7] MFD: ASIC3: add ASIC3 IRQ numbers
Date: Fri,  5 Jun 2009 18:31:03 +0200
Message-Id: <1244219467-32136-4-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
References: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ number definitions for PWM, LED, SPI and OWM (ds1wm).

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 include/linux/mfd/asic3.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index 6b427ec..d2ecaaf 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -30,6 +30,13 @@ struct asic3_platform_data {
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

