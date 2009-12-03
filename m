Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZLCVQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZLCVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZLCVQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:16:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZLCVQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:16:58 -0500
Date: Thu, 3 Dec 2009 22:16:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86/reboot for v2.6.33
Message-ID: <20091203211654.GA25830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-reboot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-reboot-for-linus

One small consistency fix only.

 Thanks,

	Ingo

------------------>
Xiaotian Feng (1):
      x86/reboot: Add pci_dev_put in reboot_fixup_32.c for consistency


 arch/x86/kernel/reboot_fixups_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 61a8377..201eab6 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -80,6 +80,7 @@ void mach_reboot_fixups(void)
 			continue;
 
 		cur->reboot_fixup(dev);
+		pci_dev_put(dev);
 	}
 }
 
