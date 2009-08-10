Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZHJJFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZHJJFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZHJJF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:05:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55453 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZHJJF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:05:29 -0400
Date: Mon, 10 Aug 2009 11:05:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Tan, Wei Chong" <wei.chong.tan@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Message-ID: <20090810090506.GA9746@elte.hu>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <B28277FD4E0F9247A3D55704C440A140D5ADEC74@pgsmsx504.gar.corp.intel.com> <20090805080647.GC30307@elte.hu> <B28277FD4E0F9247A3D55704C440A140D5D683F3@pgsmsx504.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B28277FD4E0F9247A3D55704C440A140D5D683F3@pgsmsx504.gar.corp.intel.com>
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


* Tan, Wei Chong <wei.chong.tan@intel.com> wrote:

> > Thanks. I've zapped the original patch from x86/urgent. Linus's 
> > patch certainly looks feasible for .31 if it solves the problem 
> > and if we can merge it in the next few days.
> 
> Hi,
> 
> Linus's patch looks good to go.  I've tested it with 2 separate 
> versions of BIOS, each 1000 cycles, without any wrong CPU 
> frequency being reported.  In contrast, the same CPU/platform 
> without the patch will almost consistently report a wrong CPU 
> frequency once every 20 cycles and once every 50 cycles 
> respectively, for the 2 above mentioned BIOS.

Ok, i've created a changelog out of your and Linus's mail and have 
committed the fix to x86/urgent - the -tip commit notification bot 
will send it in a few minutes.

Linus, can i have your SOB line please?

	Ingo
