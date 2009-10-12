Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZJLIlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZJLIlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZJLIlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:41:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZJLIlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:41:03 -0400
Date: Mon, 12 Oct 2009 10:40:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [origin tree build failure] [PATCH] headers: Fix build in
	drivers/net/wan/pci200syn.c
Message-ID: <20091012084012.GA14912@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012082950.GA2270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012082950.GA2270@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

  drivers/net/wan/pci200syn.c: In function 'pci200_ioctl':
  drivers/net/wan/pci200syn.c:212: error: implicit declaration of function 'capable'
  drivers/net/wan/pci200syn.c:212: error: 'CAP_NET_ADMIN' undeclared (first use in this function)
  drivers/net/wan/pci200syn.c:212: error: (Each undeclared identifier is reported only once
  drivers/net/wan/pci200syn.c:212: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/wan/pci200syn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index a52f29c..f1340fa 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/capability.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
