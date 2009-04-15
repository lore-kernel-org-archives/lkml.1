Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZDOVUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZDOVUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZDOVUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:20:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbZDOVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:20:41 -0400
Date: Wed, 15 Apr 2009 14:15:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
In-Reply-To: <20090415210353.GA27368@elte.hu>
Message-ID: <alpine.LFD.2.00.0904151406380.4042@localhost.localdomain>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu>
 <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415133255.b6a33bfe.akpm@linux-foundation.org> <20090415210353.GA27368@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Ingo Molnar wrote:
> 
> Impact line exposes wrong patch structure: cleanup should never be 
> mixed with fix.
>
> impact line somewhat atypical but correct - the patch is a cleanup 
> but might affect user-space.
>
> Impact line is correct.
> 
> Impact line is not duplicative of subject line.
>
> Impact line is incorrect (describes action not effect).
> 
> Impact line is correct and appropriate.

Bah. 

In _no_ case did the Impact: line actually say anything worth saying, and 
it was there just for self-gratification. 

> - only 0.85% of the commits you were involved with in this cycle had 
>   an impact line.
> 
> - out of 5 cases, 4 had correct impact lines, despite _you_ 
>   admittedly not liking them and not caring about them.

Just about NOBODY cares about "correct".

I care about this "mental masturbation" part, where somebody decided to 
start marking commits with some inane logic that makes no sense.

Instead of havign that IDIOTIC "Impact:" marker, why not just write good 
commit messages?

That's the issue. Those things have no meaning. 

Quite frankly, your argument of using "grep" on those things for 
management is total crap. It would make sense if they were meaningful and 
ubiquotous, but neither of those are actually true.

And your arguments are really so _incredibly_ dishonest that I don't see 
how you can't not see that yourself. Let's quote one:

> |     lockdep: warn about lockdep disabling after kernel taint, fix
> |    
> |     Impact: build fix for Sparc and s390
> |    
> |     Stephen Rothwell reported that the Sparc build broke:
> 
> I added that 'build fix' impact line for two reasons:
> 
> Firstly, because the subject line was inherited from the buggy 
> commit and the new subject line got a ", fix" postfix. (This 
> convention seems rather useful at times in shortlogs, see below.)

THIS counts as an argument for adding an "Impact:" line?

Come on - sure, it's worth mentioning that the patch is a build fix, but
that should obviously have been there regardless of any "Impact:" line. 
So your whole argument is based on the fact that you added a (good) piece 
of information, but you ignore the fact that that good piece of 
information had NOTHING WHAT-SO-EVER to do with the "Impact" line. It 
should have been there regardless.

		Linus
