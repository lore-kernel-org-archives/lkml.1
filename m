Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbZJLOXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbZJLOXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbZJLOXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:23:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbZJLOXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:23:35 -0400
Date: Mon, 12 Oct 2009 16:22:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [origin tree build failure] [PATCH] headers: Fix build in
	drivers/char/sonypi.c
Message-ID: <20091012142246.GA1606@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012082950.GA2270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091012082950.GA2270@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

drivers/char/sonypi.c: In function ‘sonypi_irq’:
drivers/char/sonypi.c:883: error: ‘SIGIO’ undeclared (first use in this function)
drivers/char/sonypi.c:883: error: (Each undeclared identifier is reported only once
drivers/char/sonypi.c:883: error: for each function it appears in.)
drivers/char/sonypi.c:883: error: ‘POLL_IN’ undeclared (first use in this function)
drivers/char/sonypi.c:884: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
drivers/char/sonypi.c: In function ‘sonypi_misc_read’:
drivers/char/sonypi.c:925: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
drivers/char/sonypi.c:925: error: implicit declaration of function ‘signal_pending’
drivers/char/sonypi.c:925: error: implicit declaration of function ‘schedule’

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/sonypi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index fd3dced..8c262aa 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -36,6 +36,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/input.h>
 #include <linux/pci.h>
 #include <linux/init.h>
