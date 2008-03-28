Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbYC1W2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbYC1W2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYC1W2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:28:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbYC1W2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:28:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Date: Fri, 28 Mar 2008 23:28:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803272353.51901.rjw@sisk.pl> <200803281710.44576.rjw@sisk.pl> <alpine.LFD.1.00.0803280938430.14670@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803280938430.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803282328.34172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 of March 2008, Linus Torvalds wrote:
> 
> On Fri, 28 Mar 2008, Rafael J. Wysocki wrote:
> > > 
> > > Also, Rafael - do these reminder emails also go to the people who are 
> > > mentioned in the regressions (especially people who are set up as being 
> > > "handled-by" or having patches for the problem)? 
> > 
> > No, they don't.  I need to do some scriptwork to make that happen.
> 
> It would be good. Right now I know for a fact that a lot of people read 
> LKML with various filters in place (or just very spottily), so I have a 
> feeling that while people try to track regressions, many people are 
> probably less aware of these things than they should be. And sometimes the 
> "handled-by" ends up being inaccurate (maybe somebody replied to the 
> original problem, but it became obvious that it was somewhere else, and 
> they remain "handled-by" even though the person doesn't actually handle 
> it).

I generally agree, but OTOH I don't think that sending one message with
50+ addresses on the CC list will actually help a lot.  I personally don't like
to receive messages like that and tend to filter them out.

I'd prefer people to receive information regarding those regression reports in
which they are directly involved, but it will take some time to arrange that in
a reliable way.

> It would probably also make sense to add some of the bigger subsystem 
> maintainers to the Cc (and/or with a mailing list for regressions?)

Tell that to davem. ;-)

Seriously, it often is difficult to say who's the right maintainer and what
list is appropriate.
 
> I think the regression list is _extremely_ valuable, but the problem I 
> see is that it's not necessarily reaching all the involved people.
> 
> The other problem is that I think the old reports (especially the ones 
> that haven't had reporter feedback in the last two weeks) end up being not 
> just stale, but they sort at the top, so when the right people _do_ look 
> at the list, the natural way to do so with email is to look at the first 
> ones first, and they *all* tend to be stale.

Well, I can sort them in the reverse order just fine, if you prefer.

As far as closing the older ones is concerned, I'm a bit reluctant to do
that, because (1) some reporters reappear after a long period of silence (like
more than two weeks) and (2) it would create an impression that we _fixed_
more regressions than we actually did.

> So the reaction is often "need more info" or "I think this was fixed 
> already two weeks ago, but there hasn't been any reply". Which is 
> psychologically really bad, because after you've seen three or four of 
> those, you just dismiss the rest (even if the later ones then may be much 
> more relevant!)

Well, you shouldn't. :-)

> This is why I have always been advocating so aggressive culling of 
> regressions and bug-reports - stale bug-reports are worse than useless, 
> they actually _hurt_.

I don't quite agree here.  At least, they indicate that we may have an unfixed
problem and the fact that no one has taken care of it doesn't really mean we
should generally ignore it.

Thanks,
Rafael
