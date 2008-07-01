Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbYGAT5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbYGAT5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYGAT5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:57:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbYGAT5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:57:19 -0400
Date: Tue, 1 Jul 2008 21:57:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fix
Message-ID: <20080701195705.GA963@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

This should be the last x86 one for v2.6.26 AFAICS.

Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      x86: fix NODES_SHIFT Kconfig range

 arch/x86/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52e18e6..8a07f41 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -961,8 +961,8 @@ config NUMA_EMU
 	  number of nodes. This is only useful for debugging.
 
 config NODES_SHIFT
-	int "Max num nodes shift(1-15)"
-	range 1 15  if X86_64
+	int "Max num nodes shift(1-9)"
+	range 1 9  if X86_64
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"
