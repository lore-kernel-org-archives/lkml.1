Return-Path: <linux-kernel-owner+w=401wt.eu-S1764608AbXJZX0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764608AbXJZX0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXJZX0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:26:25 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59093 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751998AbXJZX0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:26:24 -0400
Date: Sat, 27 Oct 2007 01:26:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
Message-ID: <20071026232653.GF30533@stusta.de>
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4721B77F.8070102@imap.cc>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 11:46:39AM +0200, Tilman Schmidt wrote:
> On Thu, 25 Oct 2007 19:56:47 -0700, Greg KH wrote:
> > On Fri, Oct 26, 2007 at 01:09:14AM +0200, Tilman Schmidt wrote:
> >> Am 25.10.2007 00:31 schrieb Adrian Bunk:
> >> > Generally, the goal is to get external modules included into the kernel.
> >> > [...] even though it might sound harsh breaking
> >> > external modules and thereby making people aware that their code should 
> >> > get into the kernel is IMHO a positive point.
> >> 
> >> This argument seems to start from the assumption that any externally
> >> maintained kernel code *can* get into the kernel, which doesn't stand
> >> up to  reality. Once you admit that there is code which, for very good
> >> reasons, won't ever be accepted into the mainline kernel tree, what you
> >> are saying amounts to: "Code that isn't fit to be included in the
> >> mainline kernel isn't fit to exist at all."
> > 
> > What kind of code is not accepted into the mainline kernel tree for good
> > reasons?
> 
> - proprietary code

It's unclear whether distributing not GPL compatible modules is legal
at all.

And they are definitely not "very good reasons" for doing anything in 
the kernel.

> - unmaintained code

Unmaintained code in the kernel has a realistic chance of being usable 
for 5 years.

Unmaintained external code is quite likely to be unusable after
at most one year.

> - code conflicting with existing kernel structure or policy
> - code in which the concerned subsystem maintainers see no benefit

Let's fix the problems, not work around them.

There is a conflict between getting code included and ensuring some 
minimum quality of the kernel, but in many cases we could try better.

And when there's a good reason for a kernel policy, then code that
violates this policy is not a "very good reason" for anything.

> - code which its author is unable and/or unwilling to convert to
>   kernel coding standards
> - code whose author is unable and/or unwilling to defend it on LKML
>...

That's their fault, and definitely not a "very good reason" for making 
life easier for them.

> Thanks,
> Tilman

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

