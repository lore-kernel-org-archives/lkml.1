Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbZFLOHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbZFLOHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZFLOHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:07:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:57152 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZFLOHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:07:24 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20090612134940.GD32105@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop> <20090612125335.GH31845@elte.hu>
	 <1244812224.7172.146.camel@pasglop> <1244813397.7172.156.camel@pasglop>
	 <20090612134940.GD32105@elte.hu>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 00:06:14 +1000
Message-Id: <1244815574.7172.171.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 15:49 +0200, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > On Fri, 2009-06-12 at 23:10 +1000, Benjamin Herrenschmidt wrote:
> > > On Fri, 2009-06-12 at 14:53 +0200, Ingo Molnar wrote:
> > 
> > > To some extent, here, the issue is on Linus side and it's up to him (Hey
> > > Linus ! still listening ?) to maybe be more proactive at giving an ack
> > > or nack so that we can get a chance to do that final pass of ironing out
> > > the mechanical bugs before we hit the main tree.
> > 
> > Let me add a little bit more background to my reasoning here and why I
> > think having this integration testing step is so valuable...
> > 
> > It all boils down to bisection and having a bisectable tree.
> 
> I think you are way too concentrated on this particular incident, 
> and you are generalizing it into something that is not so in 
> practice.

Maybe. But maybe it's representative... so far in this merge window,
100% of the powerpc build and runtime breakage upstream comes from stuff
that didn't get into -next before.

Some of the runtime breakage in powerpc-next comes from my own bugs,
indeed, and fortunately I caught it before I asked Linus to pull.

Cheers,
Ben.


