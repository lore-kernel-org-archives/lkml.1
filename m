Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYC1Qsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYC1Qsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYC1QsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:48:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754945AbYC1QsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:48:16 -0400
Date: Fri, 28 Mar 2008 09:47:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <200803281710.44576.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0803280938430.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <200803281710.44576.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Rafael J. Wysocki wrote:
> > 
> > Also, Rafael - do these reminder emails also go to the people who are 
> > mentioned in the regressions (especially people who are set up as being 
> > "handled-by" or having patches for the problem)? 
> 
> No, they don't.  I need to do some scriptwork to make that happen.

It would be good. Right now I know for a fact that a lot of people read 
LKML with various filters in place (or just very spottily), so I have a 
feeling that while people try to track regressions, many people are 
probably less aware of these things than they should be. And sometimes the 
"handled-by" ends up being inaccurate (maybe somebody replied to the 
original problem, but it became obvious that it was somewhere else, and 
they remain "handled-by" even though the person doesn't actually handle 
it).

It would probably also make sense to add some of the bigger subsystem 
maintainers to the Cc (and/or with a mailing list for regressions?)

I think the regression list is _extremely_ valuable, but the problem I 
see is that it's not necessarily reaching all the involved people.

The other problem is that I think the old reports (especially the ones 
that haven't had reporter feedback in the last two weeks) end up being not 
just stale, but they sort at the top, so when the right people _do_ look 
at the list, the natural way to do so with email is to look at the first 
ones first, and they *all* tend to be stale.

So the reaction is often "need more info" or "I think this was fixed 
already two weeks ago, but there hasn't been any reply". Which is 
psychologically really bad, because after you've seen three or four of 
those, you just dismiss the rest (even if the later ones then may be much 
more relevant!)

This is why I have always been advocating so aggressive culling of 
regressions and bug-reports - stale bug-reports are worse than useless, 
they actually _hurt_.

			Linus
