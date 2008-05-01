Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYEAFvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYEAFvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 01:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYEAFu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 01:50:56 -0400
Received: from 1wt.eu ([62.212.114.60]:3670 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYEAFuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 01:50:55 -0400
Date: Thu, 1 May 2008 07:50:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501055045.GC18597@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <200805010242.36775.rjw@sisk.pl> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 06:19:56PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > 
> > > I do _not_ want to slow down development by setting some kind of "quality 
> > > bar" - but I do believe that we should keep our quality high, not because 
> > > of any hoops we need to jump through, but because we take pride in the 
> > > thing we do.
> > 
> > Well, we certainly should, but do we always remeber about it?  Honest, guv?
> 
> Hey, guv, do you _honestly_ believe that some kind of ISO-9000-like 
> process generates quality?
> 
> And I dislike how people try to conflate "quality" and "merging speed" as 
> if there was any reason what-so-ever to believe that they are related.
> 
> You (and Andrew) have tried to argue that slowing things down results in 
> better quality, and I simply don't for a moment believe that. I believe 
> the exact opposite.

Note that I'm not necessarily arguing for slowing down, but for reduced
functional conflicts (which slow down may help but it's not the only
solution). I think that refining the time resolution might achieve the
same goal. Instead of merging 10000 changes which each have 1% chance
of breaking any other area, and have all developers try to hunt bugs
caused by unrelated changes, I think we could do that in steps.

To illustrate, instead of changing 100 areas with one of them causing
breaking in the other ones, and having 100 victims try to hunt the
bug in 99 other areas, then theirs, and finally insult the faulty
author, we could merge 50 areas in version X and 50 in X+1 (or 3*33
or 4*25, etc...). That way, we would only have 50 victims trying to
find the bug in 49 other areas (or 32 or 24). Less people wasting
their time will mean faster validation of changes, and possibly
faster release cycle with better quality.

People send you their crap every two months. If you accept half of
it every month, they don't have to sleep on their code, and at the
same time at most half of them are in trouble during half the time
(since bugs are found faster).

> So if we can get the discussion *away* from the "let's slow things down", 
> then I'm interested. Because at that point we don't have to fight made-up 
> arguments about something irrelevant.

well, is "let's split changes" ok ?

> 			Linus

Willy

