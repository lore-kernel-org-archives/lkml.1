Return-Path: <linux-kernel-owner+w=401wt.eu-S1765124AbYBMEKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765124AbYBMEKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYBMEKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:10:44 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50648 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbYBMEKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:10:42 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.1.00.0802121904270.2920@woody.linux-foundation.org>
References: <47B1CB08.4020101@garzik.org>
	 <20080212.155853.193190548.davem@davemloft.net>
	 <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org>
	 <20080212.172051.58554658.davem@davemloft.net>
	 <1202869550.3137.182.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802121832000.2920@woody.linux-foundation.org>
	 <1202871616.3137.197.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802121904270.2920@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 22:10:34 -0600
Message-Id: <1202875834.3137.201.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 19:31 -0800, Linus Torvalds wrote:
> 
> On Tue, 12 Feb 2008, James Bottomley wrote:
> > 
> > Right at the moment, I maintain a <branch> and a <branch>-base and
> > simply cherry pick the commits between the two to do the right thing
> > when I know my volatile base has changed.  It would be very helpful to
> > have a version of rebase that new my base had been rebased.
> 
> Hey, I know, you could use.. drumroll..
> 
> 	"git rebase"
> 
> I know that's a big leap of faith, to use git rebase for rebasing, but 
> there you have it. Us git people are kind of odd that way.
> 
> IOW, if you know the old broken base, and the new base, just do
> 
> 	git rebase --onto newbase oldbase
> 
> and it should do exactly that (basically lots of automated cherry-picks).

OK, smarty-pants ... that works nicely, thanks!

I'm used to maintaining <branch> and <branch>-base, so this probably
suits my workflow better than getting the information from the reflog.

It wasn't clear from the git rebase man page that it would work like
that.

James


