Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0BDUfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:35:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933345Ab0BDUfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:35:15 -0500
Date: Thu, 4 Feb 2010 21:34:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204203452.GC24716@elte.hu>
References: <20100204170826.GA16397@elte.hu>
 <20100204173602.GA19855@srcf.ucam.org>
 <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
 <20100204181218.GA6175@elte.hu>
 <20100204181540.GA20922@srcf.ucam.org>
 <20100204185603.GA6665@elte.hu>
 <20100204190012.GA21950@srcf.ucam.org>
 <20100204191935.GC6665@elte.hu>
 <20100204192808.GC1434@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204192808.GC1434@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jerome Glisse <glisse@freedesktop.org> wrote:

> On Thu, Feb 04, 2010 at 08:19:35PM +0100, Ingo Molnar wrote:
> > 
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > 
> > > On Thu, Feb 04, 2010 at 07:56:03PM +0100, Ingo Molnar wrote:
> > > 
> > > > Do you see my argument why any user who is hit by this would categorize 
> > > > this as a kernel regression in an existing driver?
> > > 
> > > No. If a user changes configuration and gets a hang, that's a bug but not a 
> > > regression.
> > 
> > Only if it's some brand-new driver or a brand-new kernel feature for which 
> > no-one can have any prior expectations of stability. Especially if it's added 
> > in the merge window when many new drivers are added.
> > 
> > But isnt it a regression to a user if it's shipped in -rc7 appearing as a new 
> > sub-option of an existing driver?
> > 
> > I'd wager that most main-street Linux users would consider that a regression.
> >  
> > As i see it is that you are trying to have it both ways: claim it's a new 
> > driver when it comes to handling regressions, but also try to have the 
> > benefits (and adoption flux) of an old driver when it comes to facing it to 
> > users.
> 
> We have been treating KMS regression as regression, [...]

Great!

> [...] i fixed numerous regressions since it was first merged as an staging 
> driver, and i keep doing so, i try to be as much reactive as i can. I am 
> sorry you have a bad experience about it. I just wanted to add that we 
> planed to move KMS out of staging in 2.6.33 long time ago and yes maybe we 
> should have done it earlier, but no matter when we do the change you will 
> still face this bug until we fix it.

I dont think you'll ever see my complain about a bug. I dont, and i introduce 
far too many of them to have any moral basis for complaint in any case ;-)

I only questioned the validity of this initial reaction by Dave Arlie:

 | Its not enabled by default so reverting this doesn't make much sense.
 |
 | We can just treat this as a normal driver bugreport.

> So on fixing the issue front, one question do you also enable radeonfb ? if 
> so then its likely the root issue of this bug, i think kconfig should 
> forbid having both radeon kms + radeonfb but i am not sure how allyesconfig 
> behave in respect of such constraint.

Please see the bugreprt i made in this thread, under the following subject:

  hung bootup with "drm/radeon/kms: move radeon KMS on/off switch out of staging."

It has all that info and more. (i've bounced it to you privately as well)

	Ingo
