Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYKIHTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYKIHTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 02:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYKIHTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 02:19:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYKIHTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 02:19:24 -0500
Date: Sun, 9 Nov 2008 08:19:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: [git pull] scheduler warning fix
Message-ID: <20081109071915.GA15556@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Fixes a silly build warning that slipped through yesterday, sorry 
about that.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: clean up vget_cycles()


 arch/x86/include/asm/tsc.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 9cd83a8..8ee029b 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -34,8 +34,6 @@ static inline cycles_t get_cycles(void)
 
 static __always_inline cycles_t vget_cycles(void)
 {
-	cycles_t cycles;
-
 	/*
 	 * We only do VDSOs on TSC capable CPUs, so this shouldnt
 	 * access boot_cpu_data (which is not VDSO-safe):
