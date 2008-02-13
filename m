Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbYBMDAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbYBMDAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYBMDAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:00:24 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39104 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYBMDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:00:22 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.1.00.0802121832000.2920@woody.linux-foundation.org>
References: <47B1CB08.4020101@garzik.org>
	 <20080212.155853.193190548.davem@davemloft.net>
	 <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org>
	 <20080212.172051.58554658.davem@davemloft.net>
	 <1202869550.3137.182.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802121832000.2920@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 21:00:16 -0600
Message-Id: <1202871616.3137.197.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 18:35 -0800, Linus Torvalds wrote:
> 
> On Tue, 12 Feb 2008, James Bottomley wrote:
> > 
> > Yes, this is exactly the feature I'm looking for.  It would allow the
> > downstream users of a rebased tree to rebase themselves correctly.
> > 
> > All the information about the rebase is in the reflog ... it can't be
> > too difficult to pass it through on a pull and allow the downstream tree
> > to do the right thing.
> 
> Guys, you simply have no idea what you're talking about.
> 
> Those downstream trees can have done things themselves. They *depended* on 
> the state you gave them.
> 
> You can't just say "oops, I lied, this is the state you should have used, 
> now it's _your_ mess to sort out".
> 
> OF COURSE it's what you'd like to use - it absolves you of any and all 
> actual responsibility. But dammit, that's not what anybody else wants than 
> the irresponsible person who cannot be bothered to stand up for his work!
> 
> If you're not confident enough about your work, don't push it out! It's 
> that simple. Pushing out to a public branch is a small "release".
> 
> Have the f*cking back-bone to be able to stand behind what you did!

Erm, I would like this feature as a downstream user.

I'm not asking for this to be the default or even easily available.
However, when you know you've based a downstream tree on what you know
to be a volatile base, it would be very useful information to have.

Right at the moment, I maintain a <branch> and a <branch>-base and
simply cherry pick the commits between the two to do the right thing
when I know my volatile base has changed.  It would be very helpful to
have a version of rebase that new my base had been rebased.

Basing on a tree I know to be volatile is sometimes a development
decision I make as a downstream user ... I'm just wishing the tools
could help me handle the problems better.

James


