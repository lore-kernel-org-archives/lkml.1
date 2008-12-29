Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYL2PGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYL2PGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYL2PGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:06:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYL2PGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:06:31 -0500
Subject: [PATCH] x86: io_apic.c io_apic_sync should be static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 20:34:35 +0530
Message-Id: <1230563075.26564.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/io_apic.c:709:6: warning: symbol 'io_apic_sync' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 62ecfc9..6991172 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -706,7 +706,7 @@ static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 }
 
 #ifdef CONFIG_X86_64
-void io_apic_sync(struct irq_pin_list *entry)
+static void io_apic_sync(struct irq_pin_list *entry)
 {
 	/*
 	 * Synchronize the IO-APIC and the CPU by doing
-- 
1.5.5.1



