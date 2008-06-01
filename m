Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYFAOYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYFAOYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYFAOYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:24:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41563 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbYFAOYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:24:14 -0400
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, tytso@mit.edu,
       benh@kernel.crashing.org,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
References: <20080529124548.GC8065@mit.edu>
	 <20080529.135431.235149338.davem@davemloft.net>
	 <20080529211404.GH8065@mit.edu>
	 <20080529.143921.34376298.davem@davemloft.net>
	 <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 09:24:09 -0500
Message-Id: <1212330249.3373.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-01 at 16:11 +0200, Thomas Gleixner wrote:
> On Thu, 29 May 2008, David Miller wrote:
> > From: Theodore Tso <tytso@mit.edu>
> > Date: Thu, 29 May 2008 17:14:04 -0400
> > 
> > > On Thu, May 29, 2008 at 01:54:31PM -0700, David Miller wrote:
> > > > Yes, process is important, but I'd say it deserved 1/3 of the summit
> > > > time, but not one minute more.
> > > 
> > > We were about 50-50 last time, roughly.  So let's see if there is
> > > consensus to dial it back this year, based on topics that people
> > > suggest.
> > 
> > Today at LinuxTAG, Thomas Gleixner and I tossed around the idea
> > that (assuming a 3 day event) we do tech stuff on day 1, process
> > stuff on day 2, and back to tech stuff on day 3.
> > 
> > The idea is that you hash out the initial impressions of your
> > ideas on day 1, your mind works on the problem in the background
> > on day 2, and they everyone has the answers on day 3 :-)
> > 
> > Another idea we discussed briefly was some kind of organized run
> > over the bugzilla entries.  And just to make it interesting we could
> > award some silly prize to whoever fixed the most interesting or
> > amusing bug during the bug-run, as voted by the attendees.
> 
> I thought more about it and came up with an interesting challange for
> the top hackers crowd:
> 
> Fix NOHZ/CPUIDLE along with suspend/resume on all participants
> laptops, which are probably 50+ different models. That'd be an odd
> enough mix of wreckaged hardware / BIOS / ACPI.
> 
> Should be fun and solve a bunch of hard to grok bugs in the bugzillas
> along the way.

Well ... in theory.

In practice, for instance, my laptop had suspend/resume working shortly
after I got it, and the widescreen video too.  Most of the problems were
video related, so I did interact with the upstream intel video driver
people, but by and large it was a set of black magic rules to restore
the video to its prior state (in my case, even the vbe tools didn't work
and I had to manually save and restore the pci config space).

The point, though, is I'd be incredibly surprised if a kernel hacker had
an unfixed suspend resume problem (except possibly one that just
appeared in the latest upgrade).  It's a fairly important feature and
hackers tend to get annoyed by problems like this and hack on them until
they're fixed.

However, persuading us all to go to the fix my suspend/resume session at
the plumbers conf (which follows directly) would probably achieve a
fairly sizeable crossection of unfixed laptops and possibly quite a lot
of bug fixing ...

James


