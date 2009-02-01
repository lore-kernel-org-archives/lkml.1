Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbZBAQiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbZBAQiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZBAQiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:38:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:43453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZBAQiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:38:06 -0500
Subject: [PATCH -tip V2] x86: irqinit_32.c fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 22:07:39 +0530
Message-Id: <1233506259.5737.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From baf127da04513547ef292079c91147eefed333a3 Mon Sep 17 00:00:00 2001
From: jaswinder <jaswinder@JSR.SATNAM>
Date: Sun, 1 Feb 2009 21:15:19 +0530
Subject: [PATCH] x86: irqinit_32.c fix compilation warning

Fix:

  arch/x86/kernel/irqinit_32.c:124: warning: 'smp_intr_init' defined but not used

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irqinit_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index ddf3eb7..520e6c1 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -154,9 +154,9 @@ static void __init smp_intr_init(void)
 
 static void __init apic_intr_init(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	smp_intr_init();
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
-- 
1.6.1



