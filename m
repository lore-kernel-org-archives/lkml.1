Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZIKTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZIKTnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZIKTnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:43:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbZIKTnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:43:11 -0400
Date: Fri, 11 Sep 2009 21:43:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/debug for v2.6.32
Message-ID: <20090911194302.GA29256@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-debug-for-linus

 Thanks,

	Ingo

------------------>
Rafael J. Wysocki (1):
      x86: Decrease the level of some NUMA messages to KERN_DEBUG


 arch/x86/mm/srat_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 29a0e37..6f8aa33 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -215,7 +215,7 @@ int __init get_memcfg_from_srat(void)
 		goto out_fail;
 
 	if (num_memory_chunks == 0) {
-		printk(KERN_WARNING
+		printk(KERN_DEBUG
 			 "could not find any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
@@ -277,7 +277,7 @@ int __init get_memcfg_from_srat(void)
 	}
 	return 1;
 out_fail:
-	printk(KERN_ERR "failed to get NUMA memory information from SRAT"
+	printk(KERN_DEBUG "failed to get NUMA memory information from SRAT"
 			" table\n");
 	return 0;
 }
