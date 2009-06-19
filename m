Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZFSGuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZFSGuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZFSGuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:50:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56735 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbZFSGuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:50:00 -0400
Date: Fri, 19 Jun 2009 08:49:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca
Subject: Re: [GIT PULL] percpu for 2.6.31
Message-ID: <20090619064911.GC8162@elte.hu>
References: <4A39F5B4.1070305@kernel.org> <alpine.LFD.2.01.0906181421460.16802@localhost.localdomain> <20090618143959.62858ef6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618143959.62858ef6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 18 Jun 2009 14:22:20 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 18 Jun 2009, Tejun Heo wrote:
> > > 
> > > Please pull from percpu-for-linus git tree from:
> > > 
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus
> > 
> > I'm very unhappy with this kind of crap.
> 
> AFACIT none of these patches have ever been in linux-next.  Half 
> or more of them turned up on the mailing list for the first time 
> two days ago and there's little evidence that anyone has even 
> looked at them.

Hm, i've seen many of them (for months literally) and you were 
definitely Cc:-ed to all of them. The new bits (which i think you 
are referring to) are not included in this series - only the old 
bits.

I even asked you about them a month ago, whether you'd want to pick 
Tejun's bits up into -mm because they are clearly generic VM patches 
and they seemed to be falling between the cracks for v2.6.31. I had 
two small bits of x86 relevant percpu patches which i'd gladly have 
bounced over to you.

Btw., it will be a lot of work for Tejun to go through another 3 
months with a patch-set of this magnitude:

  170 files changed, 653 insertions(+), 553 deletions(-)

and i suspect it will cause a fair amount of linux-next conflict 
resolution overhead as well. So Tejun, if you can get it tested 
please consider targeting it for this merge window still. I can
help out with some -tip testig if you want.

	Ingo
