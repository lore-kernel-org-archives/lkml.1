Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZHXT2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZHXT2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZHXT2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:28:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45332 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753067AbZHXT2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:28:06 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] genirq: Prototype handle_nested_irq()
Date: Mon, 24 Aug 2009 20:28:04 +0100
Message-Id: <1251142084-9852-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is supposed to be called from the primary IRQ handler
for a demultiplexing chip so make a protype visible for them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/irq.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5550b62..ae9653d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -290,6 +290,7 @@ extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_nested_irq(unsigned int irq);
 
 /*
  * Monolithic do_IRQ implementation.
-- 
1.6.3.3

