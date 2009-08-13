Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZHMOiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZHMOiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZHMOiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:38:05 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38509 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbZHMOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:38:04 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@canonical.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20090813072514.GF12143@elte.hu>
References: <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org>
	 <1250094123.4000.43.camel@mulgrave.site>  <20090813072514.GF12143@elte.hu>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 09:37:59 -0500
Message-Id: <1250174279.3901.21.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 09:25 +0200, Ingo Molnar wrote:
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

You're free to disagree

> That's a very basic argument of freedom. Just consider the Gestapo 
> which was also a 'feature' to keep criminals in check. Did you know 
> that there were record low levels of petty criminality both in nazi 
> Germany and during communism (and under just about any totalitarian 
> regime)? Still nobody in their right mind is arguing that just due 
> to that they are the right social model ...
> 
> I think this DocBook limitation needs to be fixed, because there are 
> legitimate cases where a function name got too long (for no fault of 
> its own, but for properties of the name-space it is operating in), 
> and we do not want a nanny state beat it into a single line.

But your argument is bogus.  We have tons of additional rules in Linux
coding and we have a variety of enforcement mechanisms from BUILD_BUG_ON
through to checkpatch.pl.  This really doesn't have anything to do with
"freedom".

There are really two questions here

     1. Is it a good rule that our oneline docbook function summaries
        should be, well, one line?
     2. Is the enforcement mechanism for this rule adequate?

I think 1. is reasonable.  I think 2. needs work because you don't see
the problem until make doc.

James


