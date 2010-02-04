Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab0BDU5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:57:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933392Ab0BDU5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:57:50 -0500
Date: Thu, 4 Feb 2010 21:57:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204205734.GB19050@elte.hu>
References: <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
 <20100204181218.GA6175@elte.hu>
 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
 <20100204190649.GB6665@elte.hu>
 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
 <20100204193232.GD6665@elte.hu>
 <20100204115316.69beee75@jbarnes-piketon>
 <20100204202254.GA24716@elte.hu>
 <20100204123300.7497429b@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204123300.7497429b@jbarnes-piketon>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

[...]
> > That action might hang or crash his kernel, and if that user then 
> > reports:
> > 
> >   " Hey, -rc7 just hung on me after enabling this new .config option
> > it offered for the radeon driver i am using, please add this to the
> > list of regressions. "
> > 
> > is this really the right kind of reply:
> > 
> >  " Since we moved it from drivers/staging/ to drivers/ this hang you
> > are seeing is technically not a regression, we might or might not fix
> > it. "
> > 
> > ?
> > 
> > I doubt the user would be overly enthusiastic about that kind of
> > reply ;-)
> 
> Whether or not it's a regression is mostly irrelevant, it's a real bug and 
> the radeon guys are working on fixing it. [...]

Fortunately it's being worked on.

I beg to differ with your argument about it not mattering whether a bug is 
categorized as a regression: Rafael's regression list is far more prominent 
and the bugs listed there get fixed with a high likelhood.

Note that there's clear evidence of that in this very thread: the hang bug 
was ignored as a "plain" DRM non-regression bugreport, _despite_ the prior 
scrutiny in the thread, up to the moment Linus pointed it out and turned it 
into a de-facto regression ...

There's also another purpose of categorizing bugs as regressions: tester 
timeliness. We tend to treat bugs as 'plain bugs' when they are reported too 
late after a few kernel releases of the bug having been in the wild. We do 
this to encourage testers to test earlier -rc's as well, as there's a real 
tangible benefit of the 'we dont do regressions' policy: bugs get fixed and 
testers feel involved, and it's also the stage were we _can_ fix bugs with a 
lower cost to all parties involved.

But what 'timeliness of testing' can there be if new features are added in a 
late -rc and bugs are explicitly categorized as 'not a regression'?

	Ingo
