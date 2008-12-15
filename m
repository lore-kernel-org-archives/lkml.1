Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYLORoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYLORoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 12:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbYLORn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 12:43:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbYLORnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 12:43:55 -0500
Subject: [PATCH] x86: irqinit_64.c declare init_ISA_irqs before they get
	used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 23:12:25 +0530
Message-Id: <1229362945.15326.16.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

Included asm/arch_hooks.h for init_ISA_irqs
---
 arch/x86/kernel/irqinit_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index b33d02f..d1f9663 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -21,6 +21,7 @@
 #include <asm/delay.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
+#include <asm/arch_hooks.h>
 #include <asm/i8259.h>
 
 /*
-- 
1.5.5.1



