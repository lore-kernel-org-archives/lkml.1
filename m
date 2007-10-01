Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXJAQjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXJAQjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXJAQjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:39:05 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:29233 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751781AbXJAQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:39:04 -0400
X-YMail-OSG: mVZ1SBAVM1k0utE0t88KrGOth8vR66uLPKmDwrg13vqySzxCbWtHNZJY.MgDGBC.BShsUkTd2w--
X-RocketYMMF: rancidfat
Date: Mon, 1 Oct 2007 09:39:01 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Stephen Smalley <sds@tycho.nsa.gov>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <898132.45511.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Mon, 2007-10-01 at 08:07 -0700, Linus Torvalds wrote:
> > 
> > On Mon, 1 Oct 2007, James Morris wrote:
> > > 
> > > Merging Smack, however, would lock the kernel into the LSM API.  
> > > Presently, as SELinux is the only in-tree user, LSM can still be removed.
> > 
> > Hell f*cking NO!
> > 
> > You security people are insane.

I don't know if the field attracts the insane, or if being
in the field drives one there, but I'm not going to deny that
we have our share of high grade loonies.

> > I'm tired of this "only my version is 
> > correct" crap. The whole and only point of LSM was to get away from that.
> > 
> > And anybody who claims that there is "consensus" on SELinux is just in 
> > denial.
> > 
> > People are arguing against other peoples security on totally bogus points. 
> > First it was AppArmor, now this.
> > 
> > I guess I have to merge AppArmor and SMACK just to get this *disease* off 
> > the table. You're acting like a string theorist, claiming that t here is 
> > no other viable theory out there. Stop it. It's been going on for too damn 
> > long.
> 

I'm pulling the whole arguement about when is pluggable good
and when is it bad, as everybody seems inclined to use it to
support thier own position.

> If Smack is mergeable despite likely being nothing more than a strict
> subset of SELinux

Hogwash.

> (MAC, label-based,

Yes.

> should be easily emulated on top of SELinux

Sure, and I can emulate a rubber doorstop with Michealangeo's David,
that doesn't make it a good idea. And I keep seeing "should", not
"is". Emphatic assertion is not evidence.

> or via fairly simple extension to it to make such emulation
> simpler or more optimal),

Making SELinux bigger would not make it suit the typical Smack use
better. Smack is simplified, that's a major point.

> then what isn't mergeable as a separate security module?

Personally, I care about what I produced can do, and the uses to
which it will be put. I am not convinced that SELinux can do many
of the things that Smack can, and I know that a system that can
only be used effectivly by Security Professionals is not for everyone.

Smack has a different focus than SELinux. I see no need for hostility.
If SELinux wants to incorporate Smack features, that's OK with me,
but it won't make SELinux simpler. Heaven knows I have leaned heavily
on the implementation example of SELinux.


Casey Schaufler
casey@schaufler-ca.com
