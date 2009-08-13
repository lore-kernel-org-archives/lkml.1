Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZHMIrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZHMIrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZHMIrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:47:55 -0400
Received: from cmpxchg.org ([85.214.51.133]:37508 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbZHMIry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:47:54 -0400
Date: Thu, 13 Aug 2009 10:47:24 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andy Whitcroft <apw@canonical.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090813084724.GA24333@cmpxchg.org>
References: <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org> <1250094123.4000.43.camel@mulgrave.site> <20090813072514.GF12143@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813072514.GF12143@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 09:25:14AM +0200, Ingo Molnar wrote:
> 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Wed, 2009-08-12 at 10:13 -0400, Alan Stern wrote:
> > > On Wed, 12 Aug 2009, Ingo Molnar wrote:
> > > 
> > > > > And here I was thinking kerneldoc doesn't actually work 
> > > > > like that, but perhaps Randy fixed it so the initial 
> > > > > description can line-wrap?
> > > 
> > > Yes, that's what I thought too.  If kerneldoc has been fixed 
> > > then the description line certainly should get wrapped.
> > 
> > I really don't think it needs to be fixed: it's a feature not a 
> > bug.  It requires people writing kernel doc actually to think of 
> > one line summaries.
> 
> As long as the argument is that it's good to have limitations just 
> because it has good effects as well (which the gist of your argument 
> seems to be), i disagree.
> 
> That's a very basic argument of freedom. Just consider the Gestapo 
> which was also a 'feature' to keep criminals in check. Did you know 
> that there were record low levels of petty criminality both in nazi 
> Germany and during communism (and under just about any totalitarian 
> regime)? Still nobody in their right mind is arguing that just due 
> to that they are the right social model ...

Although I really like how you Godwin'd kerneldoc comments ;-), we do
have other features that are features because of their limiting effect
all over the place, don't we?  The 80-columns code rule e.g. or our
limited set of allowed indenting characters.

> I think this DocBook limitation needs to be fixed, because there are 
> legitimate cases where a function name got too long (for no fault of 
> its own, but for properties of the name-space it is operating in), 
> and we do not want a nanny state beat it into a single line.

Agreed, just as in the other rules, one should be able to bend this
one once in a while without technical consequences, i.e. without
kerneldoc breaking.
