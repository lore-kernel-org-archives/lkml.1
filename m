Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbYGSFlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbYGSFlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 01:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYGSFlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 01:41:13 -0400
Received: from 1wt.eu ([62.212.114.60]:1839 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYGSFlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 01:41:12 -0400
Date: Sat, 19 Jul 2008 07:41:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Schwartz <davids@webmaster.com>
Cc: "David@Lang. Hm" <david@lang.hm>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080719054100.GO1369@1wt.eu>
References: <alpine.DEB.1.10.0807181755590.30465@asgard.lang.hm> <MDEHLPKNGKAHNMBLJOLKEEJIOEAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEJIOEAC.davids@webmaster.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 06:51:42PM -0700, David Schwartz wrote:
> Nobody is saying you should package the exploit. If they need someone else
> to package it, they'll still need that. So the question is not if this will
> deter script kiddies but whether it will deter the people who package
> exploits for them.

Obvious exploits are generally written by random "joe hackers" to get a
name. However, most kernel exploits are really complex, and written by
the person who discover them because they're the only ones with enough
research on the problem to be able to do so (remember vmsplice ?).

> > how many people run exploits against their production systems to 'see if
> > they are fixed', very few, and those only on strict schedules
> > with lots of adnvance notice and other safeguards.
> 
> I can tell you how many run exploits against their production systems when
> they don't know the exploits exist -- zero. It takes, at a minimum, the
> knowledge that an exploit is possible. In the cases being discussed, even
> this was withheld.

People generally don't run kernel exploits on their production systems,
simply because either the exploit works as expected and the system remains
safe, or it fails, and it generally means system crashes, freezes, or will
need a reboot very soon. The same is generally true for proof-of-concepts,
but those tend to touch less things and have less side effects in case of
failure.

> Fixes will not be widely deployed on a timely basis unless, at an absolute
> minimum, it is known that there is an exploitable bug that has been fixed.

To be clear, *I* am for telling people that they might be facing a problem
(and for not releasing exploits). This is probably because I work on
slow-moving code that people upgrade once a year or so. I know that when
you're wondering whether you'll upgrade your system after that long, you
need to what it will really fix, otherwise you don't upgrade it. That's
why I include indicators when I have them, whether they are about security,
or stability.

In fact, for people always running latest version and upgrading fast,
having all the details or not does not matter much. But as soon as the
code starts to stabilize, they don't upgrade that often, and they need
justifications for an upgrade. Right now, people running 2.6.25 would
have no reason not to upgrade, considering the variety of fixes each
version still carries. People running 2.4 or 2.6.16 *need* details.
And that's even more true for people maintaining their own kernels
or backporting fixes.

However, there is a point nobody has evocated here about backports.
For a long time I've been annoyed by not finding enough information
in some commit logs. But I finally figured that it was as simple as
asking privately either the reporter or the patch author to get that
sensible information sorted out. So the only remaining hard part of
the problem is to identify possible candidates in the huge patch flow
that 2.6 mainline it. That's true too for pure bugs, except that, as
some people have already indicated, they're often better documented.

Willy

