Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYADUen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYADUen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYADUee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:34:34 -0500
Received: from www.tglx.de ([62.245.132.106]:43723 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbYADUee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:34:34 -0500
Date: Fri, 4 Jan 2008 21:34:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less
 frequently
In-Reply-To: <200801041539.27370.ak@suse.de>
Message-ID: <alpine.LFD.0.99999.0801041546230.4042@localhost.localdomain>
References: <20080103442.621670000@suse.de> <200801041317.30404.ak@suse.de> <alpine.LFD.0.99999.0801041449460.4042@localhost.localdomain> <200801041539.27370.ak@suse.de>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, Andi Kleen wrote:
> > The kernel process request that _all_ contributors run their patches 
> > through checkpath.pl and fix the problems.
> 
> That's new. When and by whom was that rule been introduced? And with what
> rationale?

Documentation/SubmitChecklist

> Even checkpatch.pl itself says to only fix the warnings that make sense.

This applies to warnings and not to errors and what I pointed out to
you was an error.

> Anyways if you care so much about space<->tabs why don't you just write
> a filter that converts spaces to tabs for incoming patches? Like it is
> traditionally done for trailing white spaces? Would be a trivial perl script.

I need to fix up your sloppiness ?

> Bothering humans with such a silly mindless thing is beyond ridiculous.

Sorry, but all the 65 other contributors to x86.git (and the other
1000 upstream contributors) are following the same rules. Most of them
just use the tools and provide clean patches upfront and none of them
ever complained about a polite request to fix things up which slipped
through.

One real reason why you should be special ? (Aside the reverse logic
of your argument: you are the only human and all others are silly
mindless hackers.)

The only thing which is beyond ridiculous is your absolute refusal to
play by the rules.

> > The review process is the 
> > same for _all_ contributors and I'm not going to add an extra Andi
> > attitude mode to it.
>  
> I wish you guys would care more about actually broken logic in patches than just 
> checkpatch.pl output. When I occasionally check git-x86 I always tend to find some 
> obviously broken patch that should have been caught during review before
> merge.

I just pointed out broken logic in your patch (vs. max_cpus) and your
answer is just sloppy hand waving ignoring my completely valid
point. After I pointed it out to you, you do not even have the modesty
of acknowledging your error. No, a second later you claim that we care
only about coding style and not the patch content itself.

Your findings of broken patches in the x86.git tree just prove that we
are all human beings, but at least the people responsible for the
x86.git tree are able to admit their mistakes and fix them without
arguing. On the other side I'm waiting since month for any response
from you on a review for a pile of obviously broken patches which you
wanted to push into 2.6.24.

Your hyprocritical crusade is annoying the hell out of me, but feel
free to ridicule yourself further.

    tglx
