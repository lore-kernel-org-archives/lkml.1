Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZADKyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZADKyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZADKyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:54:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:51604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZADKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:54:23 -0500
Subject: [PATCH -tip] x86: irq.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:22:17 +0530
Message-Id: <1231066337.27852.11.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problem

Fixes style problem:
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>

total: 0 errors, 1 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c3b395e..22f650d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -5,10 +5,10 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/seq_file.h>
+#include <linux/smp.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
-#include <asm/smp.h>
 #include <asm/irq.h>
 
 atomic_t irq_err_count;
-- 
1.5.5.1



