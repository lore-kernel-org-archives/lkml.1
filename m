Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYCYNNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYCYNNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYCYNNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:13:33 -0400
Received: from lazybastard.de ([212.112.238.170]:55431 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYCYNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:13:32 -0400
Date: Tue, 25 Mar 2008 14:12:58 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080325131258.GC11359@logfs.org>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080325122413.GA8729@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 March 2008 13:24:14 +0100, Ingo Molnar wrote:
> 
> The current visual inconsistency between subsystems makes the Linux 
> kernel appear rather unpleasant and unprofessional to new kernel 
> developers. This is not just embarrasing to us (we want to write the 
> best OS on the planet), it is also actively harmful: such a "consistent 
> style does not matter" stance turns away people who have taste and tends 
> to attract people who have no taste - which i'm sure you'll agree with 
> results in a deadly spiral if it gets strong enough.

I disagree with that assertion.  My favorite example of where
CodingStyle has gone too far is this:
	for (i=0; i<10; i++)
While the official document demands four extra spaces, I _hate_ them.
Whitespace offers visual grouping.  The lack of whitespace around the
binary operators emphasizes that one kind of grouping is stonger than
another.  Ever since this binary operator testament was added to our
Holy Canon, I started violating the coding style on purpose.  Imo this
is beyond silly.

So do I have bad taste and should I leave the kernel in favor of someone
else with better taste that is currently turned away by me?  Maybe.
Show me that person and I'll consider gardening.  Until then I'll
continue to violate the style.  Just to spite the fundamentalist
movement.

> So to turn around the argument: could you give me any reason why 
> differing coding style between subsystems, _often in blatant violation 
> of Documentation/CodingStyle_, is somehow "good" for Linux in the long 
> run? I listed numerous first-hand advantages that style consistency 
> brings and i listed numerous disadvantages created by inconsistency. So 
> i'm waiting for the list of counter-arguments - there _must_ be some 
> objective ones, besides the obvious "kernel old-timers are lazy to 
> change their ways" argument =B-)

When you reject useful patches based on "this is not our preferred
style", you piss people off.  That is a significant reason why people
choose to spend their time elsewhere.  In certain cases having people
abandon the kernel may be a net gain, in many it is a loss.

So unless you are willing to maintain every single driver in the kernel,
pissing all the maintainers off that happen to disagree with the
canonical style - if only in detail - is not a good recipe.

Don't get me wrong, I certainly see advantages in checkpatch and keeping
the style consistent.  But there are limits, where the gains no longer
justify the cost.  And the limits will never be clearly defined.  Are
some variable names better than others - sure.  Can you write a rule for
checkpatch to ensure good names - hardly.  And yet, variable names are
part of the style.

> These style differences are certainly not "wrong enough" to 
> inconvenience or displace an active maintainer (and i never made that 
> point)

It seems we both agree then.  And for the record, your mail could easily
be interpreted as if you had made that point.  Thanks for clarifying
things.

Jörn

-- 
I don't understand it. Nobody does.
-- Richard P. Feynman
