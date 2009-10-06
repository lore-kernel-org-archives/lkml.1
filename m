Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZJFQbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZJFQbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZJFQbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:31:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZJFQbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:31:12 -0400
Date: Tue, 6 Oct 2009 18:29:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006162941.GA20590@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Unless:
> 
> > _That_ i think is a lot harder to confuse with the real .31 than a 
> > v2.6.31-1234-g16123c4 version string.
> 
> .. are you saying that it would be just some automatically generated 
> thing, just a crippled form of CONFIG_LOCALVERSION_AUTO? Kind of a 
> CONFIG_LOCALVERSION_AUTO_SHORTFORM?

Yes, exactly. Not a Makefile or tag property, obviously.

> If so, then I don't hate "v2.6.31+", but at the same time, that single 
> plus-sign tells _so_much_ less than v2.6.31-1234-g16123c4 that I think 
> it's really sad and crippled.

Agreed, and in my internal testing i've made LOCALVERSION_AUTO 
compulsory long time ago.

But at least to me there's a simple benchmark: i have been confused by 
this. In one of the merge windows i thought i booted .31 vanilla while 
in fact it was a few days into the merge window already. Took me a few 
minutes to figure out why it was crashing ;-)

YMMV.

Maybe a variant of the full string:

  v2.6.31+1234-g16123c4

would be even less confusing. I tend to ignore dashes sub-consciously 
(as a 'minor versions' kind of thing) - while in this ~1 week out of the 
9 weeks of your tree's cycle it means something much more than that, and 
we dont emphasise the difference strongly enough.

But ... that's just my own experience. I also see -tip users become a 
lot more cautious for a few rc's once we go -rc1 - while they happily 
test things in the merge window (which is _way_ more dangerous than 
pretty much any post-rc1 tree you push out).

Basically IMHO the inflection point between v2.6.31 and the merge window 
is way too 'smooth', and not obviously so, and it lures people who are 
not careful enough into testing something they probably wouldnt test 
otherwise. It's a purely human thing - to a machine it's already very 
obvious what g16123c4 means - it doesnt need any of the fancy v2.6.31 
stuff either.

	Ingo
