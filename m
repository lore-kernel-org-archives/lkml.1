Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXHQE45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXHQE45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXHQE4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:56:47 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:35222 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754240AbXHQE4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:56:46 -0400
X-YMail-OSG: KX7O0J0VM1kF0EU2q7t.jtljuU6JmGZ_Mr5.dutBY9rZTZTY.KmLNtNK5lxsFHlGBeA1bBKRsw--
X-RocketYMMF: rancidfat
Date: Thu, 16 Aug 2007 21:56:44 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Pavel Machek <pavel@ucw.cz>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070816205833.GC4949@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <638227.18984.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > I will write you a Perl script which will generate a complete  
> > > and functionally equivalent SELinux policy (assuming I have enough  
> > > free time) given a file with your policy language.  But I can do this  
> > > if and only if you tell me which of the SELinux access vectors you  
> > > care about (In other words, which of the LSM hooks you want to  
> > > require "read", "write", or "execute" privileges for).  With such a  
> > > little script you could write all the "simplified" policy you want,  
> > > without having to change the kernel code at all.
> > 
> > It's all spelled out in the module. Go wild.
> 
> Kyle claims he can emulate SMACK with SELinux + perl script, but I
> don't think it is fair to force him to write that perl.

It would not surprise me particularly much if Kyle or someone
like him could produce a perl script that could generate an SELinux
policy that, when added to the reference policy on a system
described by the reference policy, could do a fair imitation of
the Smack scheme.

One point that I would like to make clear however is that the
requirement for a 400,000 line reference policy for a jumping
off point is one of the reasons for Smack. Another point that I
think is important, and the rationale behind my being a butt
on this (sorry, Kyle, I knew some one would come after me like
this, I wasn't aiming at you) is that I have seen several cases
where the flexability and capability of SELinux policy has been
asserted but the followthrough was missing. I am interested in
seeing what an SELinux policy to do what Smack does would look
like. I personally though it would be easier to write an LSM
than to write that policy.

> You want the
> code merged, so it should be up to you to do the work... or
> acknowledge that selinux ineed is smack supperset

I acknowledge that I do not know how to prove that there is no
way, using any and all of the facilities of SELinux, to duplicate
any particular facility of Smack.

I do not acknowledge it as a superset. I am not convinced that
all of the proposed SELinux eqivalence claims would actually
result in working systems.

> and argue that SMACK
> is better, anyway, because of its simplicity / speed / something.

My understanding of the current SELinux philosophy is that
policy should only be written by professionals, and that this
was "always" the intention. I respect that, and for policy that
requires the level of sophistication that SELinux does I would
have a hard time arguing otherwise.

One of the things that limited the widespread adoption of MLS
systems was that the policy, even one as simple as Bell & LaPadula,
was considered to complex for most uses. I do not see that SELinux,
or AppArmor for that matter, addresses this fundimental impediment
to the use of mandatory access control. Yes, you can do just about
anything with the right combination of classes, booleans, and
other interesting facilities, but you can't do simple things
directly.

I was actually quite pleased to see the beginings of an SELinux
policy "equivalent" for Smack. I am disappointed that there is
insufficient wind in the sails to follow through with it. I
would like to compare, contrast, and benchmark against it. I just
don't want to write it.

> Or maybe that perl script is impossible to write for some reason? Tell
> us if so...

Goodness Pavel, it's perl! A good sysadmin can do anything in perl!
Seriously, maybe he could do it. For the reasons above, I'd be happy
to see the attempt. I would love to debate the Smack vs. SELinux
question with real data. I am not much concerned with comparisons
based on assertion and speculation. I have gotten some very good,
meaty comparison data for guardbox applications (Thanks Joshua)
and I look forward to more.

> 							Pavel
> 				(who is no security expert)

You just don't want the rock star lifestyle.

... And thank you for suggestions.


Casey Schaufler
casey@schaufler-ca.com
