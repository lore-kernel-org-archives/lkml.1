Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYADSHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYADSHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 13:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYADSGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 13:06:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:60942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYADSGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 13:06:52 -0500
Date: Fri, 4 Jan 2008 19:06:50 +0100
From: Andi Kleen <ak@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64
	early boot code with dynamic table II
Message-ID: <20080104180650.GA2998@bingen.suse.de>
References: <20080103442.621670000@suse.de> <200801041338.08093.ak@suse.de> <20080104144140.GA4203@elte.hu> <200801041603.58358.ak@suse.de> <20080104175128.GB31382@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104175128.GB31382@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is then considered "obvious style issues" are today implemented
> as errors / warnings in checkpatch for the most part. Not everyone

In my experience checkpatch has a lot of false positives. e.g. when 
I run it over my pile 20+% of the warnings are just bogus. And in
a lot of other cases it is that the rules of thumbs it applies
do not apply to that specific case. 

e.g. example: when you have self test debugging code it is perfectly
fine to not use KERN_*

> agrees with what checkpatch says are errors/warnings but this is at
> least an more or less unambigious way to express these obvious cases.

It's not -- checkpatch is often wrong. 

> And this is far better than the maintainers choice of the day style.

You mean the one from Ingo with the random new lines? @) Perhaps.
I just ask that people use some common sense.

> > Same for tabs versus spaces. That is something no human should
> > need to care about. And it is something a machine can handle fine too 
> > anyways.
> Things turn red in my vi if no-one cares 

That's a problem of your vi. I'm sure it can be turned off.

Fortunately it's easily fixed.

>- and I have no magic tool
> to fix it here.

I wrote one now.

ftp://ftp.firstfloor.org/pub/ak/perl/converttabs

As you can see it was trivial.

> No-one should submit patches with white-space errors - thank you.

No I disagree. If white space is suddenly that important -- it is still
unclear to me why that should be -- then the right way to handle that is 
at the maintainer level while merging patches. But rejecting patches
for reasons that a trivial script can fix up is just unnecessary friction
in the merging process and unnecessary bureaucracy.

Unnecessary bureaucracy defined as in rituals that do not 
actually improve any code or prevent bugs (or even style). I must say I find 
it a little sad that Linux is dissolving into that now. Ok perhaps
it is the eventual fate of anything that has been around for quite a long time,
but it seems to get worse much quicker recently.

Anyways I have the script above included now here in my patch setup
scripts so future patches of mine will have tabs.

But the problem with your "rule" is that every of the hundreds
of Linux kernel contributors will need to do the same. And that's just 
ineffecient, waste of valuable human work and just doesn't make much sense.

It certainly won't improve Linux in any way.

-Andi

