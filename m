Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab0BDRgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:36:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60838 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552Ab0BDRg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:36:27 -0500
Date: Thu, 4 Feb 2010 18:36:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204173612.GA23398@elte.hu>
References: <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
 <20100202154656.GD27314@elte.hu>
 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
 <20100204062619.GA29154@elte.hu>
 <20100204071705.GA28403@elte.hu>
 <20100204164859.GA17878@srcf.ucam.org>
 <20100204170826.GA16397@elte.hu>
 <alpine.LFD.2.00.1002040913420.3707@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002040913420.3707@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Feb 2010, Ingo Molnar wrote:
> 
> > Well, once i applied the revert i got no more hangs or crashes today, in 
> > lots of bootups. This is fully repeatable - if i re-apply that commit 
> > with the config i sent the hang happens again.
> 
> But that's just because when it was in staging, you'd never enable it, 
> right? Because your config generator always turns off staging stuff. IOW, 
> it's not the code - it's more an interaction with how your test-bed works.

Correct. Staging drivers can crash and there's no guarantee of quick 
regression fixes (although fixes are generally quick so this isnt a 
complaint), so i exclude them from boot testing.

Anyway, i've essentially moved it back to staging as far as my testing goes, 
that solves the problem too.

Thanks,

	Ingo
