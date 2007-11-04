Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbXKDNhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbXKDNhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbXKDNha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:37:30 -0500
Received: from thunk.org ([69.25.196.29]:49279 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbXKDNh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:37:28 -0500
Date: Sat, 3 Nov 2007 20:04:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Remigiusz Modrzejewski <lkml.only@maxnet.org.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Policy on dual licensing?
Message-ID: <20071104000443.GB30710@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Remigiusz Modrzejewski <lkml.only@maxnet.org.pl>,
	linux-kernel@vger.kernel.org
References: <slrnfiopoa.9cu.lkml.only@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnfiopoa.9cu.lkml.only@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 12:14:15PM +0000, Remigiusz Modrzejewski wrote:
> 
> We've all seen the last flame war about Linux stealing BSD code. Due to
> Theo's bad wording whole discussion rolled around the question about
> legality of this, a big waste of time (question answered a thousand
> times). Still, the question about ethics is quite valid...

Please let's not restart the flame war then.  The ethics question is
never going to be settled on LKML.  There are some people who believe
that a GPL license *does* make the world a better place, since it
doesn't allow a company like NetApp to take a open-source licensed OS,
make millions off of it, and not be obligated to contribute changes
back.  There are other people who believe that the BSD license is
morally and/or ethically superior because it allows NetApp to make
millions off of BSD 4.2/3 code, and they don't see any reason why such
a corporation should be obligated to give their improvements back ---
and that the existence of a BSD-licensed OS which allows this makes
the world a better place.

This is the essense of the of the BSD vs. GPL philosophical divide.

Then there are those who believe that it is morally and ethically
consistent not to obligate a company like NetApp to give back to the
original project from when it claim, and yet it is morally and
ethically consistent to try to lay a guilt trip on the Linux project
when they do exactly same thing as NetApp, except they are using a GPL
license instead of propietary licese.  

There are also who believe that such an attempt represents the height
of hypocrisy on the part of the whiners in the BSD camp.  And, of
course, there are those who think the BSD folks are being incredibly
silly, but who are personally willing such gestures in the name of
inter-project amity, while thinking that trying to make any kind of
blanket policy statement is folly.

If you haven't guessed, I'm in the latter camp.

> There are over four hundred C source files that mention BSD, but only 
> a hundred of them is dual licensed. Of course not all mentions of BSD
> mean the file is derived from it, as well as not each such licensed file
> must use the acronym.  No matter what the scale really is, the problem
> exists.

First of all, just because it mentioned BSD doesn't necessarily mean
that it came from BSD.  For example, I wrote the /dev/random driver
spceifically from Linux, but dual licensed it because I wanted the BSD
camps to pick it up.  Secondly, you're presupposing that it is a
*problem*.  There are those who believe that there is nothing wrong,
either morally, ethically, or legally, with taking BSD code, and not
dual-licesing it when adding GPL-specific additions.  You are begging
the question by just asserting that it is a _problem_.  Some people
view the GPLv2 license as a feature, not a bug.  

At the end of the day, people can choose whatever license they want.
BSD people have intentionally said they don't care if a NetApp takes
there codes and makes adds proprietary licensed code around it, when
they specified a BSD license.  The Open Solaris people have
intentionally said they don't want this, by picking a license which is
GPLv2 incompatible.  People who choose the GPLv2 license, either for a
new driver or when they add Linux-specific glue code as part of a port
of a driver, are also making their own statement.

> What I propose is implementing a policy on accepting such code.
> According to it, every time a maintainer is considering a driver
> that is derived from BSD and licensed GPL-only, should request
> for dual licensing before accepting the patch. If the submitter is
> reluctant to do so - what can we do, it's better to have this inside
> this way than not at all. However, this should minimize such cases 
> and, hopefully, satisfy the claims about Linux maintainers not doing 
> all that they could to make the world a better place.

Actually, again, you're begging the question.  I have no doubt that
people who write code under a BSD, CDDL, or GPL license all believe
they are making the world a better place in their own way.  For you to
say that Linux maintainers who don't try to get more drivers dual
licensed === not making the world a better place is just as unfair as
asserting that people who only make their code under the CDDL is doing
so only because they are trying to make their Sun options stop from
being underwater (blub blub blub :-).

						- Ted
