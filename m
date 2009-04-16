Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZDPAqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZDPAqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZDPAqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:46:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49655 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZDPAqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:46:07 -0400
Date: Thu, 16 Apr 2009 02:44:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, hpa@zytor.com, tglx@linutronix.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416004430.GA22616@elte.hu>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com> <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain> <20090415.142326.97287514.davem@davemloft.net> <20090415224800.GA22425@elte.hu> <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904151608470.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 16 Apr 2009, Ingo Molnar wrote:
> > 
> > So do you consider it wrong to summarize impact?
> 
> No.
> 
> NOBODY is arguing against talking about what the thing does.
> 
> We're arguing against the string "Impact:", which is nonsensical.
> 
> > Does this argument extend to other summaries as well, such as 
> > the title itself?
> 
> Umm. The summary line that doesn't have such a made-up nonsensical 
> prefix?
> 
> Ingo, you're missing the _point_.
> 
> Summaries and good description of patches are GOOD.
> 
> The "Impact:" string is just noise.
> 
> Talk about how it was a cleanup all you want, and by all means 
> talk about what the intention of it was. Nobody argues against 
> that. What we argue against is ugly language.
> 
> Describe the changes in real sentences.

So would a:

   The impact of this change: it is a pure cleanup.

Formalization be acceptable? We tried to make it short and fit into 
a single line - but we can certainly make it longer.

Btw., we have a _lot_ of 'summary' tags in commit logs already, all 
over the place. Added by you, me and everyone who commits changes 
into Linux.

They might not be nearly as intrusive and repulsive to you as the 
now infamous "Impact: " line, but they are all over the place and 
boy are they ugly to any sane person on this planet - you just got 
used to them already.

Starting with the title:

      x86: rename .i assembler includes to .h
      x86: add instrumentation menu

That 'x86:' prefix is a summary and a prefix string. We dont say 
what the English, Finnish, Swedish, Hungarian or German teacher 
taught us to be proper language:

      The x86 architecture code: rename .i assembler includes to .h

      Den x86 arkitekturen koden: ge nytt namn .i assembler omfattar till .h 

Because we found that too long, and because after a few months of 
getting used to everyone parses "x86: " prefixes automatically.

Just like we learned to parse "fuse: " prefixes a few years ago and 
do it sub-consciously now - despite it being arguably bad language 
(what is there to fuse??).

In fact, the .i and .h abbreviations are summarized information 
meaningless to anyone outside of this field. Often we use language 
variants specific to one Linux subsystem. Worklet? Syslet? skb? vma? 
Signed-off-by? Cc:? RIP? ALSA?

We sometimes paste formal descriptions into changelogs, when it 
serves us well:

    // <smpl>
    @disable is_null@
    identifier f;
    expression E;
    identifier fld;
    statement S;
    @@
    
    + if (E == NULL) S
      f(...,E->fld,...);
    - if (E == NULL) S

And abbreviations, summaries and ways of expressions evolve. They 
evolve when people start using them in new ways. Does it happen 
often? Yes, it does. Can it be bogus and harmful? Yes, it can be and 
most often it _is_ bogus, so scrutinizing it is correct.

So the real question is not artificial abbreviations, but the 
_level_, _style_, _efficiency_ and _placement_ of such summarizing, 
and whether you accept an "Impact: " prefix as a meaningful and 
worthwile way to summarize a given category of information. You 
clearly dont, and i dont for a minute dispute that you find it 
genuinely ugly, and i'm not ignoring your view about that.

You just dont seem to understand why i find it useful. You also seem 
to try to deprive us the basic right of creating new, field-specific 
language variants we find useful in our everyday work. And that 
sucks.

q.e.d.

Oops, i should have said, quod erat demonstrandum.

	Ingo
