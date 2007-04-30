Return-Path: <linux-kernel-owner+w=401wt.eu-S1423518AbXD3SJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423518AbXD3SJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423494AbXD3SJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:09:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33560 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423518AbXD3SJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:09:41 -0400
Date: Mon, 30 Apr 2007 20:09:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070430180952.GC23336@stusta.de>
References: <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com> <20070429201729.GQ3468@stusta.de> <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org> <20070429210505.GS3468@stusta.de> <alpine.LFD.0.98.0704291419310.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704291419310.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 02:24:03PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 29 Apr 2007, Adrian Bunk wrote:
> > > 
> > > Kernel bugzilla has 1600 open bugs BECAUSE IT SUCKS.
> > 
> > OK, how do you suggest to track bugs in a way that doesn't suck?
> 
> I've tried to explain.
> 
> Bugzilla can be one _part_ of it, but anybody who thinks it's the "main 
> part" is really not being realistic. It's too cumbersome, and it's too 
> stupid. 

I do completely agree with you on this.

The main parts are people doing some sorting and forwarding of an 
incoming bug (currently mostly Andrew) and someone with deeper subsystem 
knowledge looking deeper into a bug (currently often missing).

> Quite frankly, "lkml + google" is probably in many ways a *better* way to 
> search for problems. But yes, some manual smarts (and the _occasional_ 
> pointer to bugzilla) is probably currently the only option.
> 
> Exactly because I don't think anybody has shown any better automation than 
> bugzilla. But that doesn't make bugzilla "the One Choice". That's not how 
> it works. If there is no automation, manual tracking is still better than 
> *crap* automation.

I had the regressions stored in a plain textfile.

For getting regressions reasonably grouped for my regression emails, I 
used paper, pen and scissors - and this is not a joke.

That really didn't scale when we had 36 regressions.

So some tool is needed if the bug numbers are bigger - no matter whether 
it's Bugzilla or speaking plain SQL to a database, or anything else.

> > Bug reports to linux-kernel have the big problem that they are lost if 
> > no developer immediately picks them up.
> 
> ..and this is different from bugzilla exactly _how_?
> 
> Those things are lost too. As you yourself have pointed out. The fact that 
> you can search for them is _exactly_ as relevant as the fact that you can 
> search for lkml on google.

It depends on how you look at bugs.

My ideal was always that reported bugs should be fixed.

If you accept that this is anyway impossible because more bugs get added 
than could get fixed you might not need any tracking at all.

> > What I do know is that the majority of them has never been proper 
> > debugged by a kernel developer knowing the subsystem in question.
> 
> And you blame the developers, but not bugzilla? Why are you so unable to 
> see bugzilla as part of the *cause* of the problem? You're perfectly happy 
> to blame other things, but bugzilla is somehow above blame?

If Andrew forwarded a bug reported in Bugzilla to a developer, and 
the developer doesn't answer, is this Bugzilla's fault? Or in any other 
way worse than a bug report direct to the developer?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

