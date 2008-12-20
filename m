Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYLTNak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYLTNak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYLTNad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:30:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36107 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYLTNac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:30:32 -0500
Date: Sat, 20 Dec 2008 14:30:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Mohr <andi@lisas.de>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [patch] Re: [Bug #12100] resume (S2R) broken by Intel
	microcode module, on A110L
Message-ID: <20081220133022.GA11252@elte.hu>
References: <1229728524.5122.13.camel@earth> <20081220131946.GA31366@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220131946.GA31366@rhlx01.hs-esslingen.de>
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


* Andreas Mohr <andi@lisas.de> wrote:

> Hi,
> 
> On Sat, Dec 20, 2008 at 12:15:24AM +0100, Dmitry Adamushko wrote:
> > I'd appreciate if someone with an appropriate system might give a try to the
> > 2nd patch (titled "fix a comparison && deadlock...").
> > 
> > 
> > In any case, the deadlock situation is a must-have fix.
> 
> YES, that actually fixed it!!
> 
> Built -rc9, booted 3 times and suspended, always deadlock upon resume.
> Patched -rc9, make modules_install, suspended 3 times, always fine.

great!

> Weird, I thought I had attempted all (most?) of the parts that your 
> patch references before...
> 
> Thanks a lot for your very responsive handling!
> 
> I suppose this can get to -urgent now, JIT for the Christmas release?

yeah, i've now moved it over to tip/x86/urgent, thanks Andreas!

	Ingo
