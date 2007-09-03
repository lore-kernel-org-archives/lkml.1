Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXICC61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXICC61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXICC6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:58:13 -0400
Received: from keil-draco.com ([216.193.185.50]:50518 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbXICC6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:58:08 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: davids@webmaster.com
Subject: Re: GPL weasels and the atheros stink
Date: Sun, 2 Sep 2007 22:57:54 -0400
User-Agent: KMail/1.9.6
Cc: espie@nerim.net, linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKMECFGJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMECFGJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709022257.54663.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 22:01:17 David Schwartz wrote:
> > Letting aside the legality of that change, why would such a change
> > be needed ? The licensing is perfectly clear: the file is available
> > under the ISC licence, OR the GPL licence.  This doesn't cause any
> > problem for the linux kernel. The ISC licence is perfectly compatible
> > with the GPL (note to GPL trolls: this new licence does not have any
> > advertizing clause, which was the ONLY issue with the old licence). And
> > heck, they can use the code under the GPL licence. There is no
> > incompatibility
> > in there.
>
> Your entire argument is based on the false assumption that these licenses
> are compatible. They are not. You cannot put code that was offered under
> the GPLv2 into code that is licensed under the dual license and distribute
> the result.

Then go yell at Mr. Floeter. The code is dual-licensed and he put BSD-License 
only code in it. Because that's the *EXACT* *SAME* thing you're talking 
about.

IANAL, but your argument is specious - if the code is dual-licensed and you 
are going to let one person add code to it that is only licensed under one of 
those licenses, you *CANNOT* complain when somebody else does it and chooses 
the other license. (Well, you can, but the complaint has no legal standing)

> > The only possible issue is related to paranoia: if this file stays
> > dual-licenced, some of its code may escape from the GPL shrine, and
> > become available to the cuddly BSD people... but since their licence
> > doesn't protect anything, it could used by the Evil Empire of Microsoft,
> > or SCO, or whoever is the villain of the month.
>
> That's not the problem. The problem is that if the file stays
> dual-licensed, everyone working on that file in the Linux kernel will have
> to be careful not to put any GPLv2-only code into it. That's just
> untenable. Any consistent license is better than different files being
> under different licenses such that you can't cut and paste code between
> files.

Then why aren't you complaining about Mr. Floeters code ?

His code doesn't maintain the dual-license. I think the reason is that you 
could care less about the "Dual License" and you just want the code - period.

> > Let's extend the story a wee little bit. It seems that these days, some
> > parts of the opensource community have gotten confident enough that they
> > do not need the other part. We all know the situation is already fairly
> > disymetric. The GPL is less free than the ISC licence for instance (for
> > some definition of free), and practically, this makes it impossible to
> > add GPL code to an ISC project without putting the project under the
> > Aegis of the GPL licence. The reciprocal relationship does NOT hold. As
> > you can see in various places, it is quite possible to put BSD code
> > inside a GPL project without any issue (the FSF libiberty is a nice proof
> > of that. And heck, the glibc as well... Read carefully past the COPYING
> > file, you'll find numerous instances of BSD-like licences).
>
> If you embed protectable elements from GPLv2-only code into any of those
> files, they are no longer dual-licensed. You wind up creating traps and
> complexity that makes the code much harder to maintain.

The same can be said of Floeters code. *ALL* of his code, IIRC, is 
*SINGLE-LICENSE*. ie: a complexity trap. But you aren't complaining about his 
code - you are complaining that somebody is doing the same thing, but is 
using the side of the dual-license you don't like.

Nothing *LEGALLY* actionable there.

<snip>
> > Do you really think he's going to keep his work under a
> > dual-licence, seeing
> > how a bunch of rabid linux zealots are all but intent on stealing his
> > code whenever they can.
> >
> > Nice going, GPL fan-boys...
>
> A dual-license is a compromise. One of the downsides is that you may force
> large projects that are under one license or the other to fork the code. If
> that bothers you, don't dual license.

Exactly.

If you want to only have your code available under a specific license but rely 
on dual-licensed code, you create a fork that contains the new code under 
that side of the license. For instance: Suppose I've written a new filesystem 
and released it with three licenses - CDDL, BSD/ISC and GPL(v2) - and a Linux 
developer decides to import my FS into Linux. But the code isn't optimal for 
Linux, so he fixes it - and only wants his code usable under the GPLv2 - he 
can do this - it just means that that fork isn't usable under the other two 
licenses.

Note that the boundary of what a "work" consists of is complex - but as far as 
a computer program goes it is "the collection of source code needed to build 
the functional result" or "the functional result". 

This means that I can contribute as much code as I want to a project under 
whatever license I choose, but the project itself can have a different 
license. In the case of the code in question, that means that the second Mr. 
Floeters code was distributed as a part of the "whole work" that constitutes 
the Atheros driver it automatically fell under the dual-license of the 
controlling project. When Jiri downloaded the code and began the work of 
porting it to Linux, he accepted the terms of the GPL license - his choice to 
make. However, the initial patches altered the licensing of files that, 
individually, have a different license. That was illegal and pointed out to 
him - and that code *WAS* *NOT* accepted into Linux.

In other words: everyone claiming that Jiri making changes that are GPLv2 only 
is illegal needs to learn the law. And Theo's statement about Alan Cox fully 
constitutes Libel (Slander?). (I've never looked into the specifics of those 
laws - so I'm not sure which one e-mail falls under, however it is one of 
those)

To the 90% of the people that are following Theo's lead and bitching that they 
can't import Jiri's changes because they are solely GPL:

STFU, OK ? -- Your position isn't legally tenable *AT* *ALL*.
(Okay, so it might be that any Atheros driver containing Jiri's changes loses 
the dual-license because of the viral nature of the GPL... IANAL, but I can't 
see that happening in this case.)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
