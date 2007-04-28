Return-Path: <linux-kernel-owner+w=401wt.eu-S1031229AbXD1TxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031229AbXD1TxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031228AbXD1TxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:53:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37555 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031225AbXD1TxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:53:09 -0400
Date: Sat, 28 Apr 2007 21:53:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070428195320.GZ3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 02:13:08PM -0700, Linus Torvalds wrote:
>...
> (I've said this before, but I'll say it again: one thing that would 
> already make bugzilla better is to just always drop any bug reports that 
> are more than a week old and haven't been touched. It wouldn't need *much* 
> touching, but if a reporter cannot be bothered to say "still true with 
> current snapshot" once a week, then it shouldn't be seen as being somehow 
> up to those scare resources we call "developers" to have to go through 
> it).
>...

And if it's a bug in an unmaintained subsystem, a user could do this for 
100 weeks without any effect.
There's no value in keeping reporters busy with useless tasks. [1]

Don't forget:
A good bug report is an important contribution.

We are already quite good at ignoring bug reports that come through 
linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
than 1600 open bugs because this tells how bad we are at handling bugs.
How many thousand bug reports have been ignored during the same time on 
linux-kernel?

If a developer asked for further information and the submitter didn't
answer within 1 months, I will close this bug. [2] And "I will" is not
talking about the future, I'm doing this in the kernel Bugzilla for
three years or so.

The problem is we have tree states of subsystems and drivers:
- unmaintained
- maintained [3]
- maintained and maintainer looks after bug reports

I do hereby promise you to manually ask the submitters of all 1600 open 
bugs in the kernel Bugzilla within one month whether their problem is 
still present with 2.6.21 and forwarding all bugs if the answer was 
"yes" to whoever is the right recipient if you promise me that all bugs 
where the submitter said "yes" will be debugged by a kernel developer 
who knows the corresponding subsystem. [4]

> 		Limis

cu
Adrian

[1] "Still present with the latest kernel?" is a valid question
    if a developer intends to debug further, but otherwise it's silly.
[2] sometimes a bit later, but I'll do it
[3] I'll not do public maintainer bashing, but we have very active 
    maintainers with nearly zero activity in debugging user bug reports
[4] I don't think you'll do - but if you do that's a serious offer

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

