Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0BTKPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 05:15:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0BTKPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 05:15:17 -0500
Date: Sat, 20 Feb 2010 05:14:50 -0500 (EST)
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Message-ID: <1919069044.2010911266660890495.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <211660974.2010861266660371958.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Andi Kleen" <andi@firstfloor.org> escreveu:

> On Fri, Feb 19, 2010 at 10:14:17PM -0200, Mauro Carvalho Chehab
> wrote:
> 
> Mauro,
> 
> > I was thinking on a way where we could work with the EDAC/MCE
> issues, and
> > a way for us to move ahead. My proposal is to organize an EDAC/MCE
> BoF session
> > or a mini-summit during the Collaboration Summit, in San Francisco,
> with 
> > the interested parties. I suspect that some of us will be there
> already. 
> 
> I didn't plan to be there so far. A BoF is probably a good idea,
> and also looking closely at EDAC together,
> but it would be better at some more kernel focussed conference.
> 
> If everyone else is at that summit I can try to come,
> but it would be likely difficult.

I'm proposing the Collaboration Summit due to its date: it will
happen in April. The next Kernel conf will be on a longer time.

> We could probably do some kind of online BoF shorter time
> (e.g. using some chat setup or on the phone)

We may try to do some discussions via chat before it, but I still
think that having we all at the same room with some whiteboard
will better work.
 
> > It shouldn't be hard to find some place there for us to take a look
> at the
> > EDAC architecture and come with some proposal.
> 
> Proposal for what exactly?
> 
> Is this for a event interface or for a topology interface or both
> or something else entirely?

We should define the topics. I think we should discuss both topics.
I agree that the better is to represent the hardware per FRU. So,
maybe we can find a better topology representation.

> My personal plan so far was to work on the APEI interface
> and then possibly look at migrating MCE to that infrastructure too,
> while updating mcelog to talk to it. This would be mostly
> addressing events so far.

The better is to have some discussions before using APEI or any other
interface for it. It should be considered that the hardware errors
should be presented on a consistent way not only for newer processors
and memory controllers, but also for the already supported ones.

> > As today is the last day for CFP, I've also submitted there a
> proposal for a
> > panel. If approved, we can use it to collect data from hardware
> error users
> > (sysops and other users that require high availability on their
> services),
> > for us to discuss some strategies to address the issue or to
> summarize what
> > will be discussed on the event.
> 
> You want to collect error rates or want to collect use cases?
> 
> For a serious collection doing it online would probably
> give better coverage.
> 
> I do both to some degree already.

Both data collect are important (and I also do it to some degree),
and we can do it via other means, but a face-to-face meeting may
help to vallidate any ideas we may have about improvements/changes
at the interfaces and features.

If we succeed on such discussions at the planning phase, this will
save us a lot of development time and will help to have an easier
upstream adoption.

So, I think it is a worthy try.

Cheers,
Mauro
