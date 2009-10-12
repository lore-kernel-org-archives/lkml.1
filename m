Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZJLKHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZJLKHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZJLKHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:07:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbZJLKHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:07:22 -0400
Date: Mon, 12 Oct 2009 12:06:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [origin tree build failure] [PATCH] headers: Fix build in
	drivers/char/genrtc.c
Message-ID: <20091012100635.GA15126@elte.hu>
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

drivers/char/genrtc.c: In function ‘gen_rtc_interrupt’:
drivers/char/genrtc.c:168: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
drivers/char/genrtc.c:168: error: (Each undeclared identifier is reported only once
drivers/char/genrtc.c:168: error: for each function it appears in.)
drivers/char/genrtc.c:186: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
drivers/char/genrtc.c:186: error: implicit declaration of function ‘signal_pending’
drivers/char/genrtc.c:186: error: implicit declaration of function ‘schedule’

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/genrtc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index aac0985..31e7c91 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -43,6 +43,7 @@
 #define RTC_VERSION	"1.07"
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/fcntl.h>
