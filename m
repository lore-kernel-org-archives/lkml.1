Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbXFNT03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbXFNT03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXFNT0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:26:15 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4585 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbXFNT0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:26:13 -0400
Date: Thu, 14 Jun 2007 15:09:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, dcbw@redhat.com,
       hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org,
       marcelo@kvack.org
Subject: Re: libertas (private) ioctls vs. nl80211
Message-ID: <20070614190936.GA28917@tuxdriver.com>
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org> <20070614103836.23b07a72.akpm@linux-foundation.org> <20070614181307.GA16856@infradead.org> <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 11:23:11AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 14 Jun 2007, Christoph Hellwig wrote:
> >
> > > I suspect that the probability of your proposal succeeding would be increased
> > > if you could prepare a patch...
> > 
> > Here we go:

FWIW, I do appreciate the patch rather than just mere
complaining... :-)

> I don't mind ripping them out, but it makes sense only if people are 
> actually signed up to implementing this on a higher layer. As such, I'd 
> need to get a sign-off from somebody actually involved in wireless mesh 
> stuff etc.

I'm not aware of any project working on wireless mesh in mac80211 at
the moment, serious or otherwise.  I think one would be worthwhile,
but I don't know of anyone working on it.

> Please? I do agree that the private iwpriv interface seems to be totally 
> the wrong thing to do, but I want to see this as a first step towards a 
> better situation, rather than just a "remove code that is ugly" issue!

Private wireless extensions are ugly, even uglier in some ways than
normal private ioctls.  However, they have been used in the past for
just this sort of thing (i.e. something a given driver can do but is
not generically available).

We don't have either generic functionality
for mesh in mac80211 or even other drivers doing mesh on their own,
so there is nothing to validate a generic configuration option.
Further, while the beginnings of nl80211 are available it will still
be some non-zero time before it is even mature enough to replace
truly generic configuration facilities in the wireless extensions.

> Comments?

Aside from simply carrying an out-of-stream patch, the OLPC and
libertas driver people would have only the alternative of hacking-up
a debugfs configuration regime.  Is it worthwhile to obligate them
to either alternative?  What is to be gained?

It does not make sense to me to rip this out purely for aesthetic
reasons.

John
-- 
John W. Linville
linville@tuxdriver.com
