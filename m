Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYCYMYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYCYMYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYCYMYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:24:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbYCYMYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:24:34 -0400
Date: Tue, 25 Mar 2008 13:24:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080325122413.GA8729@elte.hu>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080325111129.GB11359@logfs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Tue, 25 March 2008 11:48:41 +0100, Ingo Molnar wrote:
> > 
> > So, in the specific example of the scheduler subsystem, i've only 
> > observed advantages to checkpatch and zero downsides. Could anyone 
> > give me _any_ objective reason why i shouldnt be using checkpatch 
> > for the scheduler? More broadly, could anyone give me an objective 
> > reason why we shouldnt be doing it for arch/x86? And even more 
> > broadly, could anyone give me an objective reason why we shouldnt be 
> > doing it for all actively maintained areas of the kernel?
> 
> Disagreement between checkpatch and maintainers preferred style. I've 
> had a patch that fixed a bug and - while in the region - "cleaned up" 
> the style for a single line.  This line no longer matches the rest of 
> the file and creates the kind of visual distraction you complain 
> about.

well, once a subsystem is "checkpatch-clean" (which my challenge above 
obviously assumes), there's no such "partial style" problem. It 
obviously also assumes that the maintainer agrees that having consistent 
coding style across all of Linux is a long-term advantage.

The current visual inconsistency between subsystems makes the Linux 
kernel appear rather unpleasant and unprofessional to new kernel 
developers. This is not just embarrasing to us (we want to write the 
best OS on the planet), it is also actively harmful: such a "consistent 
style does not matter" stance turns away people who have taste and tends 
to attract people who have no taste - which i'm sure you'll agree with 
results in a deadly spiral if it gets strong enough.

So to turn around the argument: could you give me any reason why 
differing coding style between subsystems, _often in blatant violation 
of Documentation/CodingStyle_, is somehow "good" for Linux in the long 
run? I listed numerous first-hand advantages that style consistency 
brings and i listed numerous disadvantages created by inconsistency. So 
i'm waiting for the list of counter-arguments - there _must_ be some 
objective ones, besides the obvious "kernel old-timers are lazy to 
change their ways" argument =B-)

In my experience in almost all cases the "style disagreement" between a 
subsystem maintainer and checkpatch is due to the _maintainer_ being 
wrong about seemingly unimportant (to him) style details.

And that very much includes myself: i used to have such "disagreement" 
with checkpatch errors and i used to be annoyed at the style nitpicking 
of checkpatch. And yes, it takes a certain amount of time for a 
long-time kernel hacker like me to realize that a lot of code i wrote in 
the past needs a good clean-up ;-)

These style differences are certainly not "wrong enough" to 
inconvenience or displace an active maintainer (and i never made that 
point), but they are nevertheless a death by a thousand cuts that the 
general kernel is suffering from right now, and i'd be a fool not to 
point it out. These seemingly unimportant style details add up to a 
hodgepodge of coding style that makes life difficult for people who have 
to look at many different parts of the kernel that they _dont maintain_.

That's why i asked about specific examples that we can talk about - and 
i gave specific examples and filenames. The checkpatch maintainer (Andy 
Whitcroft) has certainly shown flexibility to fix false positives ASAP.

> Of course when a maintainer likes checkpatch, as you do, there is no 
> disagreement to deal with. :)

note, all those patches are "Subject: x86: " and 99% of them is 
maintained by us x86 maintainers.

	Ingo
