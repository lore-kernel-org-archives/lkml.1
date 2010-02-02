Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab0BBPpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:45:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0BBPpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:45:05 -0500
Date: Tue, 2 Feb 2010 16:44:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100202154450.GC27314@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
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


* Dave Airlie <airlied@linux.ie> wrote:

> > It's the moving of radeom KMS out of staging after -rc6 that causes it, 
> > because it brought it into the scope of my testing:
> > 
> >  f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
> > 
> > So at least on this box it's clearly not ready for mainline enablement 
> > yet. I've attached the revert patch further below.
> 
> Its not enabled by default so reverting this doesn't make much sense.

I boot allyesconfig kernels regularly, which testing method works fine with 
another 2000+ upstream drivers. (including the dozens of drivers which match 
to active hardware components on that box)

> We can just treat this as a normal driver bugreport.

Commit f71d0187 is post-rc6, so i'm not sure it fits your "this is business 
as usual, lets move on" characterisation.

Thanks,

	Ingo
