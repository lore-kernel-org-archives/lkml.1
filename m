Return-Path: <linux-kernel-owner+w=401wt.eu-S1031410AbXD2Uim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031410AbXD2Uim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031412AbXD2Uim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:38:42 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:58191 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031410AbXD2Uil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:38:41 -0400
Message-ID: <46350240.6070605@simon.arlott.org.uk>
Date: Sun, 29 Apr 2007 21:38:24 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org>
In-Reply-To: <20070429180909.GA30604@one.firstfloor.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/04/07 19:09, Andi Kleen wrote:
>>  - a lot of reporters will not use bugzilla, because it's damn 
>>    inconvenient even for reporting. If you propose something that uses 
> 
> Don't think that's true. There are plenty of projects who only
> accept bugs through bugzilla (mozilla, various distributions, etc.) 
> and I don't see any evidence of your claim being true.

These projects are probably losing plenty of trivial bug reports 
from people who shouldn't have to register with a bug tracker and 
fill in a long form every time to submit a short bug report.

> Sure there will be always people who cannot be bothered
> to use any kind of interface for bugs, but then

Most of the time bugzilla appears to be a great way to ignore 
bugs. Every large project seems to have one with bugs that 
stay open for years - bugzilla's own inability to quick search 
without javascript[1] being a good example (it's fixed now). 
If no one can get around to fixing reported bugs why should 
anyone bother submitting more?

They even released their software with a link to the bug if 
you tried to do a quick search without javascript:
[1] https://bugzilla.mozilla.org/show_bug.cgi?id=70907
"THIS BUG IS FIXED IN BUGZILLA 2.22. D..."

> these are unlikely to stay on board during a longer 
> remote debugging q'n'a session either. So those people
> can be just ignored; they essentially don't exist in
> the bug report universe.

How will the people you ignore get their bugs fixed?

> I don't think the "keep it in Andrew's/Adrian's head" method
> is going to scale longer term at least (and one of them has 
> already thrown in the towel) 

People are doing something about this, at least for tracking 
the regressions at http://kernelnewbies.org/known_regressions 
(which is read-only unless you register, people have already 
commented on this).

> The "send it to a gigantic mailing list and hope someone catches
> it" method also doesn't seem to be that great. At least there
> are lots of lost reports in my experience this way.

I have had experience of this with the dvb mailing list (this was 
a couple of months before their news post referencing bugzilla 
too), even when I included a patch to fix it.

Someone suggested another way to fix a bug and I replied that it 
worked - that fix never went anywhere else and other people could 
be having the same problem today because it's still not been 
applied anywhere. (I will submit a -1 +1 patch myself when 
I have time this week).

> I suspect the real reason is more "Linus doesn't like web interfaces
> for no particular good reason". Not much can be done about that.
> Well perhaps someone can write a gopher based bugzilla interface 
> or something to solve that instead @) 

Bugzilla's advanced search interface is far too crowded, that 
should be clear to anyone. The simpler search usually isn't much 
use because either it finds too many bugs or "zarro boogs" and 
you're left wondering if the bug is there or not.

-- 
Simon Arlott
