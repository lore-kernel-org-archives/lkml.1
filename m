Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYKUNLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYKUNLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYKUNLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:11:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYKUNLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:11:45 -0500
Date: Fri, 21 Nov 2008 13:11:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jim Radford <radford@galvanix.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       Matt Fleming <mjf@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] ftrace: mcountrecord.pl for arm
Message-ID: <20081121131109.GA12241@flint.arm.linux.org.uk>
References: <20081120203415.251344054@goodmis.org> <20081120220406.GA2159@blackbean.org> <20081120221149.GA2470@blackbean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120221149.GA2470@blackbean.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 02:11:49PM -0800, Jim Radford wrote:
> Ingo and Steven,
> 
> Here's an updated version of the arch/arm changes for dynamic ftrace
> based on top of your latest tip/master.

Excuse me if I'm rather confused, but...

When ftrace for ARM was originally merged, neither linux-arm-kernel
nor myself were copied with the patches.  Now, I'm being sent updates
to code that I've no understanding of and haven't seen before.

I mean, yes, it's nice to be copied with patches which are relevent.
It would've been even nicer to have been copied with the patches adding
ftrace in the first place, so people knew something about it and were
aware of the changes.

It seems to me like there's been a total breakdown of communication
when ftrace was initially merged...

So, questions: has ftrace actually been tested on ARM at all?  Has it
been reviewed?  Which ARM platforms has it been tried on?  How stable
is it?  How has it been implemented on ARM?  Does it rely on any CPU
specific behaviour?

Looking at the git history, ftrace was merged via Ingo, so I assume
that Ingo has some understanding of this code.  So, for the time being
if these are urgent updates, I suggest that updates go through Ingo's
tree rather than mine.

And looking at arch/arm/kernel/ftrace.c, it's incompatible with Thumb2
which we've been working towards supporting.  What about SMP?  ARM is
a SMP capable architecture now, and I see no locking in there - what
I do see is static data with pointers to it being returned to other
code... Yuck.
