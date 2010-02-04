Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0BDUrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:47:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab0BDUrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:47:09 -0500
Date: Thu, 4 Feb 2010 21:46:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100204204655.GA19050@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
 <20100202154450.GC27314@elte.hu>
 <21d7e9971002041239i5e842698pd8a775f833fc5d51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9971002041239i5e842698pd8a775f833fc5d51@mail.gmail.com>
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


* Dave Airlie <airlied@gmail.com> wrote:

> On Wed, Feb 3, 2010 at 1:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Dave Airlie <airlied@linux.ie> wrote:
> >
> >> > It's the moving of radeom KMS out of staging after -rc6 that causes it,
> >> > because it brought it into the scope of my testing:
> >> >
> >> > ?f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
> >> >
> >> > So at least on this box it's clearly not ready for mainline enablement
> >> > yet. I've attached the revert patch further below.
> >>
> >> Its not enabled by default so reverting this doesn't make much sense.
> >
> > I boot allyesconfig kernels regularly, which testing method works fine 
> > with another 2000+ upstream drivers. (including the dozens of drivers 
> > which match to active hardware components on that box)
> 
> Okay this was something I wondered about, since these are *not* 
> allyesconfig .configs, I've generated some and CONFIG_FB_RADEON is always 
> on here, and you seem to not have that enabled (not that enabling it is a 
> good idea it is in fact a really bad idea).

These were random configs - the size doesnt match an allyesconfig, those are 
way bigger. My above comment related to the first crash, and to my argument 
that all other drivers are fine during bootup - and there's a lot of them.

> So do you have something you are running after allyesconfig to fix things? 
> or have you just got a config that is close enough to allyesconfig.
> 
> I'm building kernels with your .config now and boot testing them on the 
> full range of hardware I have/

Thanks. Is there something i can enable to get a better log for you to find 
out where (and why) it's hanging? It's still early during bootup so the box 
is not particularly debuggable - so i'm not sure i can get a task list dump, 
etc., unfortunately.

	Ingo
