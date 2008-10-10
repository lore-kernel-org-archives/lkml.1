Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbYJJQ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbYJJQ50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762103AbYJJQ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:57:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37529 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761830AbYJJQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:56:59 -0400
Date: Fri, 10 Oct 2008 18:56:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #2 - PAT updates
Message-ID: <20081010165647.GA4363@elte.hu>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010164537.GA23664@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > which makes both the original commit _and_ the revert just totally 
> > pointless, because we didn't learn anything.
> 
> hm, those reverts werent supposed to survive. Again, my bad. I'll 
> clean it out.
> 
> Here is how the screwup happened: a series was sent, i applied it, 
> found a test failure with it and reported it:
> 
>   http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.1/2388.html
> 
> but to be able to continue testing i temporarily reverted those bits 
> manually in reverse order, because it took some down to pin down the 
> breakage and these bits got intermixed with other commits - and i did 
> not want to rebase commits that came after the broken series.

Correction: i did the reverts shortly before applying the v2 series - so 
it was fully technical. I wanted to do a line by line review of the fix 
(and did it), because the lockup took quite some time to pin down. To 
avoid this mistake i could also have hard-reset the full v1 series and 
could have redone the whole topic.

What's the best Git way to avoid such mishaps? I try to avoid resets and 
rebases of already pushed out bits as much as possible, because that is 
both risky because information can be lost and asocial because ongoing 
work of contributors can be disturbed.

	Ingo
