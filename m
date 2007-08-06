Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbXHFLFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbXHFLFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXHFLF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:05:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbXHFLF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:05:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
Date: Mon, 6 Aug 2007 13:14:41 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, Len Brown <lenb@kernel.org>,
       Paul Mackerras <paulus@samba.org>
References: <200708051906.22865.rjw@sisk.pl> <20070806090713.GC15329@atrey.karlin.mff.cuni.cz> <1186392591.28655.35.camel@johannes.berg>
In-Reply-To: <1186392591.28655.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061314.42632.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 11:29, Johannes Berg wrote:
> On Mon, 2007-08-06 at 11:07 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > +config SUSPEND_UP_POSSIBLE
> > > +	bool
> > > +	depends on (X86 && !X86_VOYAGER) || (PPC32 && PPC_MPC52xx) \
> > > +		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM || BLACKFIN \
> > > +		   || MIPS || SUPERH || FRV
> > > +	depends on !SMP
> > > +	default y
> > 
> > I guess I'd rather left SUSPEND_UP_POSSIBLE to allways y (as it always
> > was), and let architectures that can't handle it  not return "mem"
> > from list of valid states...
> 
> Yeah, that's the utterly broken interface we used to have. Until I fixed
> it to have no valid states until architectures implement suspend_ops.
> Still, I disagree, why bother with compiling code that can't ever be
> used?

Yes, that's the idea.

BTW, Pavel please see: http://lkml.org/lkml/2007/8/3/303

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
