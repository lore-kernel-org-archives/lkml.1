Return-Path: <linux-kernel-owner+w=401wt.eu-S1750896AbXAXJyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750896AbXAXJyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 04:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXAXJyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 04:54:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbXAXJyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 04:54:06 -0500
Date: Wed, 24 Jan 2007 10:51:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-ID: <20070124095157.GA21346@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <1169604991.19471.95.camel@imap.mvista.com> <20070124070701.GA17654@elte.hu> <1169631016.19471.175.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169631016.19471.175.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > i disagree. Thomas' tree has been tested in -rt for some time 
> > already, and he's the author of this code so as far as i'm concerned 
> > he calls the shots of what to do and in what order to do. He did the 
> > overwhelming majority of regression fixes of dynticks/hrt stuff both 
> > in -mm and in -rt. So why should i not take his queue over yours? 
> > Last i checked your queue didnt really do anything substantial to 
> > the code - other than shuffling around wast amounts of code around. 
> > Even this latest iteration from Thomas that is now in -rt is working 
> > well on the target platform we are aiming for currently (i686). (and 
> > it's working on x86_64 as well in -rt)
> 
> The majority of the new code was added yesterday in -rt8. [...]

please read what i wrote: in the first section above i am talking about 
Thomas' -hrt tree and its track record. Thomas' tree is more than a year 
old and has an excellent track record. In the last sentence i was 
talking about this latest iteration of his -hrt tree, which i released 
as part of -rt yesterday. (but which i have tested internally longer 
than that, prior release.)

> Since this new release has a fair amount of new code it's not totally 
> fair to says "it's been in -rt for a while".

Thomas' -hrt tree has been in -rt for over a year.

> If stability is a question, -rt10 does currently compile for my test 
> config, due to this new HRT introduction. [...]

isnt your test config ARM? If it's x86 or x86_64 then please send me a 
bugreport about it. rt10 wont compile on non-i686 and non-x86_64 because 
their clockevents drivers have not been updated yet (but should be 
trivial). In any case, this is an -rt internal matter that has no 
relevance on the -mm submission, i'm not sure why you are bringing it 
up.

the -mm queue Thomas sent is for i686 - other architectures wont use 
clockevents and they are expected to build and boot just fine.

> My queue has always been 90% clean up, some of that is moving code 
> around. [...]

in the -rt tree i'm tracking the high-res code that has been started by 
Thomas in mid-2005. In the past 1.5 years, 90%+ of the bugfixes to 
high-res timers issues in -rt came from Thomas and this has been about 
the 10th major iteration to his codebase. If you have cleanups to his 
code then please work with Thomas to get your changes into his tree.

	Ingo
