Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0BDVGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:06:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0BDVGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:06:18 -0500
Date: Thu, 4 Feb 2010 22:05:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204210559.GC19050@elte.hu>
References: <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
 <20100204181218.GA6175@elte.hu>
 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
 <20100204190649.GB6665@elte.hu>
 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
 <20100204193232.GD6665@elte.hu>
 <20100204115316.69beee75@jbarnes-piketon>
 <20100204202254.GA24716@elte.hu>
 <20100204204829.GA24608@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204204829.GA24608@srcf.ucam.org>
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Feb 04, 2010 at 09:22:54PM +0100, Ingo Molnar wrote:
> 
> >   " Hey, -rc7 just hung on me after enabling this new .config option it 
> >     offered for the radeon driver i am using, please add this to the list of 
> >     regressions. "
> 
> If the same configuration options hang on both an old kernel and a new 
> kernel, how is that in any plausible way a regression? What's regressed?

Regressions are not limited to 'same config' kernels, last i checked. If that 
has changed (or if i'm misunderstanding it) then it would be nice to hear a 
clarification about that from Linus.

The way i understand it is that there are narrow exceptions from the 
regression rules, such as completely new drivers for which there can be no 
prior expectation of stability by users. (but for even them we are generally 
on the safer side to list bugs in them as regressions as well - especially if 
we expect many users to enable it.)

AFAIK there's no exception for new sub-features of existing facilities or 
drivers, even if it's default-disabled.

This issue materially affects quite a few bugs i'm handling as a maintainer. 
Many of them are under default-off config options - most new aspects to 
existing code are introduced in such a way. It would remove quite a bit of 
urgent-workload from my workflow if i could strike them from Rafael's list 
and could deprioritize them as "plain bugs", to be fixed as time permits.

IMHO it would be rather counter-productive to kernel quality if we did that 
kind of regression-lawyering though.

	Ingo
