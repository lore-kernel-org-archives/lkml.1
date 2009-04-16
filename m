Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZDPHYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZDPHYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZDPHY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:24:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47353 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZDPHYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:24:25 -0400
Date: Thu, 16 Apr 2009 09:23:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416072354.GA3031@elte.hu>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu> <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain> <20090416004430.GA22616@elte.hu> <alpine.LFD.2.00.0904151757100.4042@localhost.localdomain> <20090416014642.GA24029@elte.hu> <alpine.LFD.2.00.0904151918370.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151918370.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 16 Apr 2009, Ingo Molnar wrote:
> > 
> > Show me one person _you_ actually taught to write good 
> > changelogs - just one person who was not a natural born talker 
> > to begin with. I'll show you a 100 other people who cannot write 
> > good commit logs. They'll try and will limp along, but generally 
> > they cannot.
> > 
> > They might not even have English as their mother tongue - but 
> > still can read and understand C fantastically.
> 
> So?
> 
> The fix for that is not to write crap English. The fix for that is 
> to help them, and/or just fix their comments for them.
> 
> I really don't see the point of your argument. "People don't 
> always write good and complete sentences" is _not_ an argument for 
> then making that a standard.
> 
> Just fix things up. Edit their emails. I do. Andrew does. Yes, and 
> despite that some commits will still have odd grammar or otherwise 
> not be the great novel of the century, and that's not the point. 
> But we should _improve_ on the language for people who aren't 
> native English speakers, not devolve it to something weaker.

I too end up editing the language and typography non-trivially for 
about 90% of all patches i apply, so there is certainly no lack of 
effort here either.

Moving the impact line to the tags section certainly sounds like a 
good solution to make the main flow of the commit be natural 
language - while still keeping most of the good aspects of the tag 
for those who want to use them.

So if that variant now has the official penguin-pee on it, i'd like 
to move back to maintaining^W editing commits! :)

Note: today is a flag day when i'll flip over to putting the 
impact-tag to the tail section - you'll still see impact lines at 
the head of the commit for already committed bits. They might thus 
show up in the next merge window or even later (if a topic needs 
more work than that).

Thanks,

	Ingo
