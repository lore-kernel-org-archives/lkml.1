Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbXJXLbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbXJXLbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbXJXLay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:30:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbXJXLay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:30:54 -0400
Date: Wed, 24 Oct 2007 13:30:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 arch updates
Message-ID: <20071024113043.GA11897@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

it contains two build fixes and an oops-printout-ugliness fix.

Thanks!

	Ingo

------------------>
Alexey Dobriyan (1):
      x86: fix bogus KERN_ALERT on oops

Jeff Garzik (1):
      x86: lguest build fix

Mike Galbraith (1):
      x86: fix CONFIG_KEXEC build breakage

 kernel/crash.c |    6 +++---
 lguest/boot.c  |    1 +
 mm/fault_32.c  |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)
