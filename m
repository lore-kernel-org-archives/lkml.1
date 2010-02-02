Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0BBPm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:42:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51054 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab0BBPmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:42:54 -0500
Date: Tue, 2 Feb 2010 16:42:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100202154238.GB27314@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
 <21d7e9971002020037r13de7df7t1450cecc1f4a4fea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9971002020037r13de7df7t1450cecc1f4a4fea@mail.gmail.com>
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


* Dave Airlie <airlied@gmail.com> wrote:

> On Tue, Feb 2, 2010 at 6:35 PM, Dave Airlie <airlied@gmail.com> wrote:
> > On Tue, Feb 2, 2010 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> * Dave Airlie <airlied@linux.ie> wrote:
> >>
> >>> > Hi Linus,
> >>> >
> >>> > Please pull the 'drm-linus' branch from
> >>> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> >>> >
> >>>
> >>> I've also added an oops fix I seem to lose off my radar to this tree.
> >>>
> >>> commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
> >>> Author: Michel D??nzer <daenzer@vmware.com>
> >>> Date: ? Fri Jan 22 09:20:00 2010 +0100
> >>>
> >>> ? ? drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
> >>
> >
> > Wierd this suggests something else is wrong on that machine can you get me
> > the whole dmesg? I'm guessing some iommu or swiotlb issue.
> >
> > I've asked Jerome to fix the oops, but really anyone with an old .config 
> > won't get hit by this, and we've booted this on quite a lot of machines 
> > at this point.
> 
> Ideas keep flooding in here, did you softboot from the old UMS driver? or 
> coldboot? does coldbooting help?

Btw., i have cold booted it after full poweroff, and it crashed in the same 
way.

	Ingo
