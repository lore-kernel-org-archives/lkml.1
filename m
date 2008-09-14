Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYINNZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYINNZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYINNZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:25:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56781 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYINNZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:25:43 -0400
Date: Sun, 14 Sep 2008 15:25:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
	and VESA framebuffer
Message-ID: <20080914132520.GA554@elte.hu>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200809121533.43318.elendil@planet.nl> <7E82351C108FA840AB1866AC776AEC462CA8E8B0@orsmsx505.amr.corp.intel.com> <200809131149.55472.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809131149.55472.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> On Saturday 13 September 2008, Pallipadi, Venkatesh wrote:
> > >We have too many entires in PAT list due to RAM pages being marked
> > >UC by drivers. Unfortunately, there are no quick fixes that can fix
> > >this for 2.6.27. However, we are aware of the problem here and
> > >working on a more complete fix for this. We should have the patch
> > >for it soon.
> >
> > Can you try the patch here
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0809.1/2074.html
> > And report back whether that resolves the issue.
> 
> Yes, that solves the issue. The display is now free of artifacts 
> again, both on logout and when I switch users in X. The 
> pat_memtype_list looks a lot more sane too (see attachment).
> 
> So it _was_ a regression caused by pat itself after all, and not the 
> result of incorrect memory handling in the framebuffer code. Could you 
> take over the bug report #10843 in bugzilla (it is currently assigned 
> to the framebuffer people) and ensure it gets closed once the patch 
> gets accepted in Linus' tree?

ok, since those patches are only supposed to improve performance, it 
would be nice to know why this fixes the display artifacts. They were a 
rather long-living bug and we'd like to avoid such bug patterns in the 
future.

or is it the timing effect? Too slow programming of the GX chip causes 
artifacts? (but i think this is not very likely)

	Ingo
