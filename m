Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXGQML5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXGQML5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbXGQMLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:11:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43503 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbXGQMLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:11:45 -0400
Date: Tue, 17 Jul 2007 14:11:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch] softlockup: make asm/irq_regs.h available on every platform
Message-ID: <20070717121139.GA13276@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: core: make asm/irq_regs.h available on every platform
From: Ingo Molnar <mingo@elte.hu>

the softlockup detector would like to use get_irq_regs(), so generalize 
the availability on every Linux architecture.

(it is fine for an architecture to always return NULL to get_irq_regs(), 
which it does by default.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-arm26/irq_regs.h |    1 +
 include/asm-cris/irq_regs.h  |    1 +
 include/asm-ppc/irq_regs.h   |    1 +
 include/asm-v850/irq_regs.h  |    1 +
 4 files changed, 4 insertions(+)

Index: linux/include/asm-arm26/irq_regs.h
===================================================================
--- /dev/null
+++ linux/include/asm-arm26/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
Index: linux/include/asm-cris/irq_regs.h
===================================================================
--- /dev/null
+++ linux/include/asm-cris/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
Index: linux/include/asm-ppc/irq_regs.h
===================================================================
--- /dev/null
+++ linux/include/asm-ppc/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
Index: linux/include/asm-v850/irq_regs.h
===================================================================
--- /dev/null
+++ linux/include/asm-v850/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
