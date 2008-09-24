Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYIXHnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYIXHnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYIXHm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:42:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44572 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYIXHm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:42:57 -0400
Date: Wed, 24 Sep 2008 09:42:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] timers fixes
Message-ID: <20080924074245.GA11474@elte.hu>
References: <200809240137.40403.rjw@sisk.pl> <20080924074038.GD3655@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924074038.GD3655@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	Ingo

------------------>
Marc Dionne (1):
      x86: prevent stale state of c1e_mask across CPU offline/online, fix


 arch/x86/kernel/process_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4b3cfdf..31f40b2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
+#include <asm/idle.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 

