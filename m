Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYCYODv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYCYODv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYCYODn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:03:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbYCYODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:03:43 -0400
Date: Tue, 25 Mar 2008 15:03:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080325140314.GA10569@elte.hu>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080325131258.GC11359@logfs.org>
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

> > So to turn around the argument: could you give me any reason why 
> > differing coding style between subsystems, _often in blatant 
> > violation of Documentation/CodingStyle_, is somehow "good" for Linux 
> > in the long run? I listed numerous first-hand advantages that style 
> > consistency brings and i listed numerous disadvantages created by 
> > inconsistency. So i'm waiting for the list of counter-arguments - 
> > there _must_ be some objective ones, besides the obvious "kernel 
> > old-timers are lazy to change their ways" argument =B-)
> 
> When you reject useful patches based on "this is not our preferred 
> style", you piss people off. [...]

we dont actually do that for newbies and newbies are in fact happy to 
write cleaner code - so the rest of your argument which depends on this 
premise fails. (Most of the time i fix it up silently myself or if a 
style error comes in a pattern, i ask the person to send future patches 
with that small detail fixed.)

my experience with checkpatch.pl is the exact opposite of what you fear: 
it _widened_ the contributor base: a good number of newbies felt 
encouraged that an objective piece of tool reports an "error" in a file 
that was written by otherwise "much more knowledgable" kernel hackers. 
checkpatch.pl is basically the "yes, really, you are right, this piece 
of code in the Linux kernel is indeed crap" review tool that reinforces 
newbies. It lowers the bar of entry to kernel hacking, and it does so 
for exactly those pieces of code that we want newbies to be active on: 
barely maintained source code.
 
Whoever is afraid of an "army of checkpatch wielding newbies" who'll 
never rise above their newbie status fails to consider two important 
factors: 1) checkpatch errors are a finite resource to feed on and they 
dont re-grow in a well-maintained subsystem 2) they need to look back a 
few years when they themselves were newbies and were in need of some 
easy kernel projects just to familiarize themselves with the kernel and 
its contribution environment. (My first-ever contribution to the Linux 
kernel was a trivial patch.)

( i only remember one patch ever being rejected due to checkpatch 
  failures, it came from a kernel old-timer who sent absolutely horrible 
  patches and who _should have known better_. Kernel old-timers are 
  "multipliers", they write more code and influence more people's code, 
  so it's expected of them to write absolutely squeaky-clean code. )

so at least for the scheduler and for arch/x86 there's absolutely zero 
friction between checkpatch.pl use and newbies - and if you look at the 
nicely evolving arch/x86 contributor statistics you'll have to come to 
the same conclusion i believe.

	Ingo
