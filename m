Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZDPL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZDPL5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZDPL5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:57:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:47692 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbZDPL53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:57:29 -0400
Date: Thu, 16 Apr 2009 07:57:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416115712.GL21586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Jones <davej@redhat.com>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <200904161130.28129.rusty@rustcorp.com.au> <20090416075651.GB4507@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416075651.GB4507@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 09:56:51AM +0200, Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Anyway, Impact: had lead me to think harder about my messages than 
> > the free-form commit style did.  Perhaps it's too rigid, but it 
> > helped.
> 
> btw., and i think this is the crux of the matter, Rusty was quite 
> sceptic about impact lines in the beginning, and did not like them 
> _at all_. We had discussions (months ago) about it with Rusty and he 
> had a similar position to other "read only" participants in this 
> thread.

Hmm, I guess for me what I consider ideal, and what I consciously try
to do, is to include (at most) 2-3 words that describe the impact in
the patch summary line.  Writing a good patch summary line is _hard_;
in 70-75 characters you need to describe both *why* and *what*; it
needs to be something which is both succinct, but which, several
months later, is enough so that someone scanning the patch summaries
has a fighting chance to pick out the relevant patch amongst a sea of
thousands of other patches.

And at least for me, something mechanical just isn't likely to work.
It reminds me of a story when, over 30 years ago, someone at the MIT
AI Lab wrote a proposal to create "programming for non-programmers";
it proposed creating templates so that people who didn't know how to
do things could use as a starting point, and then have expert systems
that would help fill in the rest.  Shortly after this paper was
circulated, a parody was sent out mocking the first paper, "thinking
for non-thinkers".  It suggested creating template idea for people who
weren't smart enough to create their own original thoughts, etc. 

So I'd really like to encourage try challenging people to try to write
a good patch summary line.  It may be that forcing someone to
constrain themselves to 70 characters (75 if they must) and which must
explain both the impact of the patch as well as the what the patch
does, is enough rigidity or a constraint that it might force people to
think.  Because at the end of the day, that's what we really need
people to do.

              					- Ted
