Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZDGEOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZDGEOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDGEOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:14:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbZDGEOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:14:37 -0400
Date: Mon, 6 Apr 2009 21:07:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
In-Reply-To: <9b1675090904062056v235af58ehc99cce8ff97fe501@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904062103531.4010@localhost.localdomain>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>  <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain> <9b1675090904062056v235af58ehc99cce8ff97fe501@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Trenton D. Adams wrote:
> >
> > This went through bisection, but looking at the email log, I tend to
> > suspect that maybe Trenton marked some versions good even though they
> > weren't (because they got versions numbers from v2.6.27), and didn't
> > realize that that messes up bisection in a big way.
> 
> Is it appropriate for me to respond to these things?

Yes. I added you to the cc exactly because it was hard for me to judge 
from the email discussion that is linked to in the regression list whether 
you actually _did_ mark some versions good because of confusion about the 
version numbering.

That would certainly explain why bisection didn't seem to work.

But it's not the _only_ reason bisection doesn't work. Sometimes you can 
be as careful as possible, but if it's a bug that is even _slightly_ flaky 
(timing-dependencies etc), and the bisection marked something good that 
shouldn't have been (or vice versa, but that's unusual), then the 
bisection end result won't be right.

So you may well have done everything right, and I'm not trying to blame 
you. I just was hoping that maybe that confusion would explain why the 
bisection didn't seem to pinpoint anything sane..

> I was wondering about that.  Someone had mentioned that I should trust
> the bisect, even when it takes me into "other versions", and it was
> taking me through 2.6.27, which I thought was just really weird.
> Would you like me to try the bisect again with a little more
> diligence, or do you think it can be found with the info given?  It
> may take a week or so, due to being a bit busy.

It would be good, especially if this bug doesn't end up being solved some 
other way... And slow results are better than no results at all ;)

			Linus
