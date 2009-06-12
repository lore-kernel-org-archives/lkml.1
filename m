Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbZFLNLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbZFLNLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZFLNLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:11:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:48716 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbZFLNLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:11:17 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20090612125335.GH31845@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop>  <20090612125335.GH31845@elte.hu>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 23:10:24 +1000
Message-Id: <1244812224.7172.146.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 14:53 +0200, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> linux-next has integration testing so that interactions between 
> maintainer trees are mapped and that architectures that otherwise 
> few people use get build-tested too (well beyond their practical 
> relevance, i have to add) - but there's little critical review done 
> in linux-next. Nor should it be the forum for that, it simply 
> contains way too much stuff and has a weird history format with 
> daily rebases that makes review hard and expensive in that form.

I think you are mixing several issues. One is integration testing, one
is the problem of remote architecture of subsystems testing...

> linux-next should not be second-guessing maintainers and should not 
> act as an "approval forum" for controversial features, increasing 
> the (already quite substantial) pressure on maintainers to apply 
> more crap.

I agree here. That's not the point. The idea is that for things that
-are- approved by their respective maintainers, to get some integration
testing and ironing of those mechanical bugs so that by the time they
hit mainstream, they don't break bisection among others.

Yes, next is -not- the place to debate controversial features. That's
not, I believe, why it was initiated (I may be wrong, Stephen will
correct me if I am), but the way I see things is that stuff that is
meant to be merged gets a chance to get some of that integration testing
against all the other stuff that is also meant to be merged to limit the
amount of clash and problems once we hit Linus tree.

> And that is true even if it's a new feature that i happen to support 
> - as in this case - it sure would have been handy to have more 
> perfcounters test coverage, every little bit of extra testing helps.

That doesn't invalidate my point. We are not talking about whether
perfcounters is worth merging or not, testing more or not, but strictly,
imho, about getting a chance (a couple of days at least) to do that
integration testing and catch the simple issues like the one that
triggered my initial rant -before- they hit mainline.

To some extent, here, the issue is on Linus side and it's up to him (Hey
Linus ! still listening ?) to maybe be more proactive at giving an ack
or nack so that we can get a chance to do that final pass of ironing out
the mechanical bugs before we hit the main tree.

Cheers,
Ben.

> If linux-next wants to do that then it should be renamed to 
> something else and not called linux-next.
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

