Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYBPXsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYBPXsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 18:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYBPXsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 18:48:06 -0500
Received: from www.tglx.de ([62.245.132.106]:39872 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYBPXsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 18:48:04 -0500
Date: Sun, 17 Feb 2008 00:47:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Whitcroft <andyw@uk.ibm.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] checkpatch.pl: revert wrong --file message
In-Reply-To: <20080216225637.GE24479@shadowen.org>
Message-ID: <alpine.LFD.1.00.0802170009510.7583@apollo.tec.linutronix.de>
References: <20080215165244.GA28358@elte.hu> <200802151815.44050.ak@suse.de> <alpine.LFD.1.00.0802161026550.7583@apollo.tec.linutronix.de> <84144f020802160227u59c9959emb905808cc7141f2b@mail.gmail.com> <20080216225637.GE24479@shadowen.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Andy Whitcroft wrote:
> On Sat, Feb 16, 2008 at 12:27:33PM +0200, Pekka Enberg wrote:
> > Hi,
> > 
> > On Feb 16, 2008 12:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > People, who do cleanups - I'm not talking about running lindent here -
> > > read through the code while they fix it up.
> > >
> > > Actually they find bugs that way or at least come up with useful
> > > questions about code which is not obvious in the first place.
> > >
> > > Discouraging such cleanups with a pretty offensive warning is
> > > counterproductive.
> > 
> > Well, it's not just about cleanup patches submitted by "newbies". I
> > use checkpatch for development too and the warning is real PITA for
> > that.
> 
> The warning is suppressed on -q as its a pain indeed if one is using it
> to check files and you are not intending a single file cleanup.
> 
> Is the concensus the warning is useful, or unhelpful.

The warning is wrong and annoying. It reflects the personal opinion of
Andi and imposes it on everybody else. 

There was and is no consenus about the usefulness of such patches and
probably never will be. It's up to the maintainer of a particular
subsystem to accept or reject such patches.

It's definitely not the decision of a single kernel developer who has
his own definition of checkpatch.pl correctness:

<http://lkml.org/lkml/2008/1/4/98>

> Please run your patches through checkpatch.pl.
> 
> ERROR: use tabs not spaces
> #48: FILE: arch/x86/kernel/alternative.c:360:

I saw a lot of these warnings, but disregarded them as obviously
silly. I don't have plans to redo all the patches for that.

</http://lkml.org/lkml/2008/1/4/98>


Thanks,

	tglx
