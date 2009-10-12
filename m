Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZJLIbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZJLIbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZJLIbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:31:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbZJLIbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:31:20 -0400
Date: Mon, 12 Oct 2009 10:30:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [origin tree build failure] [PATCH] headers: Fix build in
	drivers/pci/hotplug/cpqphp.h
Message-ID: <20091012083033.GA31206@elte.hu>
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

  drivers/pci/hotplug/cpqphp.h: In function ‘wait_for_ctrl_irq’:
  drivers/pci/hotplug/cpqphp.h:730: error: implicit declaration of function ‘signal_pending’

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/hotplug/cpqphp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index 5383600..9c6a9fd 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -32,6 +32,7 @@
 #include <asm/io.h>		/* for read? and write? functions */
 #include <linux/delay.h>	/* for delays */
 #include <linux/mutex.h>
+#include <linux/sched.h>	/* for signal_pending() */
 
 #define MY_NAME	"cpqphp"
 
