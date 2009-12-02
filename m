Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZLBN5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZLBN5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZLBN5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:57:30 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52359 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZLBN5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:57:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=HKZHkRAbVoCg1q/Deec6sMkweAb4LaxzkYawbHnWdYOV3n/Ik5o4471izf5ajrmt/I
         zw9NW6wh3DeAZHSO/NxQqN3rPQNF5F0rfKgbA8T70m5hw76etcOHwFrY6MjWONoI5z2b
         XArDeGuqxhEHv94GoUr42YDXfIvdUS/6B9DE8=
Message-ID: <4B1670CA.5070500@gmail.com>
Date: Wed, 02 Dec 2009 21:51:06 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 1/4]ARM: NUC900: change condition of IRQ_ADC to NR_IRQS for
 nuc932
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

For applying to nuc932, I modified the 'for' loop condition.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-w90x900/irq.c b/arch/arm/mach-w90x900/irq.c
index 5444a27..633ac8b 100644
--- a/arch/arm/mach-w90x900/irq.c
+++ b/arch/arm/mach-w90x900/irq.c
@@ -73,7 +73,7 @@ void __init nuc900_init_irq(void)
 
 	__raw_writel(0xFFFFFFFE, REG_AIC_MDCR);
 
-	for (irqno = IRQ_WDT; irqno <= IRQ_ADC; irqno++) {
+	for (irqno = IRQ_WDT; irqno < NR_IRQS; irqno++) {
 		set_irq_chip(irqno, &nuc900_irq_chip);
 		set_irq_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
-- 
1.5.6.3
