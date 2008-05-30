Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYE3BUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYE3BUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYE3BUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:20:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:47112 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYE3BUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:20:41 -0400
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Theodore Tso <tytso@mit.edu>
Cc: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080529124548.GC8065@mit.edu>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop>  <20080529124548.GC8065@mit.edu>
Content-Type: text/plain
Date: Fri, 30 May 2008 11:20:06 +1000
Message-Id: <1212110406.15633.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 08:45 -0400, Theodore Tso wrote:
> On Thu, May 29, 2008 at 04:17:19PM +1000, Benjamin Herrenschmidt wrote:
> > Having been stopped a couple of times last year when trying to bring
> > some technical subjects for the reason that they were "off topic, KS is
> > for process" I tend to agree :-)
> 
> We did have some technical topics last year.  So I don't think the KS
> will ever be purely for process.

Amen :-)

> I agree that sometimes face-to-face discussions are crucial to
> resolving technical issues.  The problem is that we try to nail down
> the agenda a 3-4 weeks ahead of time, and realistically if a
> particular topic requires certain stakeholders to be invited, we need
> to decide that we're going to do that topic at least 8-9 weeks in
> advance, maybe more, so those people can make travel plans and/or get
> travel approvals.  And there is always the chance the topic will
> resolve itself via e-mail.  So the trick is being able to identifying
> the topics where a face-to-face discussion really will be useful.

It's a bit hard, as sometimes, the topics will just show up before hand,
or don't necessarily need special invite list when it's purely something
that needs to be discussed with a good enough panel of arch maintainers.

> First of all, if there is interest in holding some topic-area specific
> mini-summits on Sunday before the Kernel Summit, we may be able to
> scare up some space.  So if there is interest, please let me know.

Ok, if something comes to mind I will :-) The only thing at this stage
would possibly be page table walking (ie, some old work I did on
that to generalize the batch interface to all more-than-one-page
operations such as fork, and to get rid of the per-cpu structures, and
that I never fully finished, along with the mmu notifier stuff and
the various needs around that area such as sleeping during some parts
of page table updates etc...).

We might finally be able to put the whole thing on a table and decide
on a nice / clean solution that I'd be happy to help implement then :-)

Among others, I have had a hard time getting enough input from the
various archs as to get to a design that would fit everybody fine.

We don't -have- to spend time on that, it's just an example, but typically
I think a good one of something that would benefit from a face to face
brainwashing with the arch maintainers & MM people.

> Secondly, one of the things which has been suggested in the past is
> that we move the BOF's into an afternoon session slot, and maybe push
> the last session to run until 7pm, perhaps.  That might make it easier
> for people to attend BOF's on the spur of the moment --- which might
> be useful in some cases where there is only 10 or so people you need
> to hash our some issue.
> 
> And, of course, we try to schedule plenty of break time so that some
> of these discussions can happy in the hallway.
> 
> Do any of these possibilities sound particularly attractive or likely
> to address your concerns?  If so, which ones do you think we should
> try this year, as an experiment?

To be honest, I don't know for sure. A bit like David, I'm not even
certain planning for those things is -that- useful and I must admit
I'm not too fan of long days mostly because I end up always getting
there totally jet lagged :-)

But we can definitely try.

Cheers,
Ben.


