Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbXFOUVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbXFOUVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbXFOUVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:21:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbXFOUVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:21:13 -0400
Date: Fri, 15 Jun 2007 22:20:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615202054.GA590@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <200706142144.15695.dhazelton@enter.net> <1181895924.25228.319.camel@pmac.infradead.org> <200706150458.29943.dhazelton@enter.net> <1181899064.25228.342.camel@pmac.infradead.org> <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org> <1181930204.25228.590.camel@pmac.infradead.org> <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org> <1181936955.5211.62.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181936955.5211.62.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> > So I really do _not_ think it's at all obvious. Personally, I think 
> > it's exactly the same case. Others disagree, but I've never really 
> > seen a good *reason* for them disagreeing.
> 
> It's a grey area, and nobody's 'right' until/unless a court decides. 
> And then only until/unless a higher court contradicts it. The reason I 
> jumped in was to point out that it isn't _just_ about whether the 
> module is a derived work or not. The GPL goes further than that.

i think you are putting too much weight behind the distinction between 
derivatives/modifications and collective works / collections. The two 
are very closely related: a derivative/modification is a work that 
arises out of an existing work, while a collective work arises out of a 
set of pre-existing works by adding some 'glue' to it (where the glue 
itself is not a work in itself - the whole thing is the new work). In 
fact one could argue that a derivative is a collective work based on a 
_single_ preexisting work!

and thus the whole issue of "what is a whole", how strong the "glue" 
needs to be so that the copyright of the collective work is meaningful 
on its own and starts to affect every component and requires each of 
them to be GPL licensed. This largely depends on how deeply a 
distributor integrates said binary blobs. For example some Linux 
distributors certainly found it safe enough to ship restricted software 
on separate medium - even if they happen to be in the same physical 
package. (which one could attempt to argue to be 'one work'.)

That boundary is indeed fuzzy, because life is fuzzy too and the 
possibilities are virtually unlimited. But one thing is pretty sure: as 
long as some component is merely put alongside of a larger body of work, 
even if that component has no life of its own without _some_ larger body 
of work, that component is not necessarily part of a collective work and 
does not necessarily fall under the GPL. (unless it falls under the GPL 
for entirely different reasons: for example it was continuously 
developed out of internals of the 'larger body of work' and thus became 
a derivative of the larger body of work.)

For driver blobs that are shared between Windows and Linux it would be 
hard to argue that they are derived from the Linux kernel. Merely 
linking to some larger body of work does not necessarily mean that the 
two become a collective work. No matter how much the FSF is trying to 
muddy the waters with the LGPL/GPL.

	Ingo
