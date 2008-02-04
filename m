Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYBDM6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYBDM6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYBDM6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:58:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbYBDM6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:58:05 -0500
Date: Mon, 4 Feb 2008 13:57:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Message-ID: <20080204125736.GA32056@elte.hu>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu> <47A4A96D.2040709@garzik.org> <20080202175738.GA26560@elte.hu> <47A4BB3C.6050709@garzik.org> <20080202193524.GC27927@elte.hu> <47A4D71F.3060009@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A4D71F.3060009@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>> so please tell me Jeff. If Greg, who is the super-maintainer of your 
>> code area, and who deals with your code every day and changes it 
>> every minute and hour, simply did not Cc: the SCSI list - how am i, a 
>> largely outside party in this matter, supposed to notice that 3 
>> maintainers and 3 mailing lists in the Cc: were somehow not enough 
>> and that i was supposed to grow the already sizable Cc: list even 
>> more?
>
> Because, regardless of the situation, it's both common courtesy and 
> wise practice to CC relevant driver maintainers, when you touch a 
> driver.
>
> And it's just common sense: Greg simply does not know the intimate 
> details of every PCI driver.  Nor do I.  Nor you.
>
> In the case of lpfc here, we have an active driver maintainer, and an 
> up-to-date MAINTAINERS entry.  Even if you are too slack to read 
> MAINTAINERS, 'git log' would have given you the same info.
>
> Don't pretend there is some benefit here to ignoring the people that 
> best know the driver.  I don't buy that; it simply makes no 
> engineering sense whatsoever.

what you _STILL_ do not realize is the following: you still attribute 
the lack of Cc:s to some intention of mine. No, it was not my intention. 
At first glance the Cc: looked large and complete enough in an 
_existing_ discussion and that's was the end of my (brief) attention 
regarding the Cc: line. Yes, it would have been a bit better had i 
noticed the lack of Cc:s in an existing discussion, but i didnt.

[ And it might not surprise you if i observe here that i think this
  little mishap is further (incidental) proof that having this many
  mailing list aliases to get the 'guaranteed attention' of maintainers 
  is just super fragile and does not serve users at all. Even Greg and i 
  got it wrong accidentally. If _we_ get it wrong, who will get it 
  right? I see several mis-Cc:ed emails every day and there's over a 
  1000 unfixed bugs in bugzilla for 2.6 alone. It does not take a genius 
  to observe that something is fundamentally wrong ;-) That 2.6 works on
  your or my box is a _very_ poor metric - we both fix bugs on our 
  systems super fast so we've got a very biased first-hand experience 
  about the stability and reliability of the kernel. We never really 
  feel the kind of frustration that testers feel when their mail to lkml 
  gets ignored. We never really feel the helplessness that comes from 
  unfixed bugs. ]

	Ingo
