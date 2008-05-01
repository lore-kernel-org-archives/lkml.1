Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYEAAnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYEAAnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYEAAnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:43:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYEAAnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:43:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 02:42:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010242.36775.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Linus Torvalds wrote:
> 
> On Thu, 1 May 2008, Willy Tarreau wrote:
[--snip--]

> I do _not_ want to slow down development by setting some kind of "quality 
> bar" - but I do believe that we should keep our quality high, not because 
> of any hoops we need to jump through, but because we take pride in the 
> thing we do.

Well, we certainly should, but do we always remeber about it?  Honest, guv?

> [ An example of this: I don't believe code review tends to much help in 
>   itself, but I *do* believe that the process of doing code review makes 
>   people more aware of the fact that others are looking at the code they 
>   produce, and that in turn makes the code often better to start with.

It may help directly, for example when people realize that they work on
conflicting or just related changes.

>   And I think publicly announced git trees and -mm and linux-next are 
>   great partly because they end up doing that same thing. I heartily 
>   encourage submaintainers to always Cc: linux-kernel when they send me a 
>   "please pull" request - I don't know if anybody else ever really pulls 
>   that tree, but I do think that it's very healthy to write that message 
>   and think of it as a publication event. ]

I totally agree with that.

Still, the issue at hand is that
(1) The code merged during a merge window is somewhat opaque from the tester's
     point of view and if a regression is found, the only practical means to
    figure out what caused it is to carry out a bisection (which generally is
    unpleasant, to put it lightly).
(2) Many regressions are introduced during merge windows (relative to the
    total amount of code merged they are a few, but the raw numbers are
    significant) and because of (1) the process of removing them is generally
    painful for the affected people.
(3) The suspicion is that the number of regressions introduced during merge
    windows has something to do with the quality of code being below
    expectations, that in turn may be related to the fact that it's being
    developed very rapidly.

My opinion is that we need to solve this issue sooner rather than later and so
the question is how we are going to approach that.

Thanks,
Rafael
