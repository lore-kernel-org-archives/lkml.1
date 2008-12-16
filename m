Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYLPDsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYLPDsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 22:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYLPDsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 22:48:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:55314 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYLPDsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 22:48:42 -0500
Subject: [PATCH] x86: irqinit_64.c init_ISA_irqs should be static
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       yinghai@kernel.org
Content-Type: text/plain
Date: Tue, 16 Dec 2008 09:17:09 +0530
Message-Id: <1229399229.3348.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/irqinit_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index b33d02f..b0611ca 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -69,7 +69,7 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
-void __init init_ISA_irqs(void)
+static void __init init_ISA_irqs(void)
 {
 	int i;
 
-- 
1.5.5.1



