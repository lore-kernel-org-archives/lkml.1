Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXD3KE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXD3KE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXD3KE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:04:28 -0400
Received: from mx.laposte.net ([81.255.54.16]:4451 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXD3KE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:04:26 -0400
Subject: Re: Linux 2.6.21
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Adresse perso
Date: Mon, 30 Apr 2007 12:03:46 +0200
Message-Id: <1177927426.22352.60.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach wrote :
> On Sun, Apr 29, 2007, Adrian Bunk wrote:
> > On Sun, Apr 29, 2007 at 01:33:16PM -0700, Linus Torvalds wrote:
> > > On Sun, 29 Apr 2007, Adrian Bunk wrote:
> > > > 
> > > > The kernel Bugzilla currently contains 1600 open bugs.
> > > 
> > > Adrian, why do you keep harping on this, and ignoring reality?
> > > 
> > > Kernel bugzilla has 1600 open bugs BECAUSE IT SUCKS.
> > 
> > OK, how do you suggest to track bugs in a way that doesn't suck?
> > 
> > Bug reports to linux-kernel have the big problem that they are lost if 
> > no developer immediately picks them up.
> 
> I suspect some bug reports get ignored deliberately.

[...]

You're probably not the only one thinking this but you know? This kind
of message makes me barf

> Y'know, a lot of developers don't just work for the money, they
> work for the fun of it. Thus they try to avoid pain and grief. :-)

Y'know, a lot of bug reporters are not paid at all, they try to help by
reporting problems.

> it's hard to write good bug reports,
[...]
> Thus they try to avoid pain and grief. :-)

It's way easier (and rewarding) to flame Linux on MLs, forums, articles
and make it a reputation darker than the darkest night than to have to
engage some developers on a bug report.

> Thus it's
> just natural that you learn from the experience to ignore every
> bug report which even remotely smells fishy ;-/

Thus it's just natural that you learn from the experience to stop
reporting problems and let some other poor sod do it, and instead spend
your time productively somewhere else

> Bugzilla just makes this visible because it doesn't forget.
> Which is stupid and discouraging for both (potential) bug
> reporters and developers.

Are you kidding? Do you think having a painfully drafted e-mail report
ignored is any less discouraging? Why do you think Adrian Bunk is
blowing a fuse today?

> And I also think that ignoring bad bug reports _increases_
> the software quality, because you can use the saved time
> working on something productive. 

All it increases is the lack of testing since ignored people stop
reporting bugs, so you have :
1. a small minority of hardened bug reporters (seems even Adrian is not
hardened enough to keep on it)
2. a majority of newbie reporters that don't know how to do clean
reports yet, and will vanish from the circuit before learning as soon as
they get the "ignored" treatment.

> And it makes developers happier :-)

That's the actual reason and it's a bad one. Unless developers have the
hardware, time and energy to do their own testing. Which is not the case
(read Andrew Morton's periodical complaints)

Now, here is what this bug reporter thinks:

1. bugzilla sucks for all the reasons written before

2. e-mail reports suck more:
- unless you post at the right time you get ignored
- you spend your time re-sending the same info because people don't read
thread histories
- you can't attach significant debugging material such as logs because
you'll hit random list size limits
- you get your mail address harversted by spammers (and if you create a
one-shut address people complain you don't consult it often enough)
- list filters will randomly decide your message is spam, and your
report will be lost
- you can't easily reassign reports once a group told you the bug is
somewhere else, you have to restart from step 1
- you don't even have the sucky target list you have in bugzilla - you
spend more time finding maintainer and list addresses than writing the
report (and then you have to monitor a gazillon of list to check if
someone read your stuff)
- people will write you "this looks the same as foo" and you'll spend
some more hours locating foo instead of having a clear pointer to
another report

e-mail is all nice and dandy for people who:
- have setup the infrastructure on their desktop to process large mail
volumes
- are behind strong spam filters
- have the clout to be listened to at once
- have all the relevant list & maintainers pointers in their head
- have helpers like Adrian to sort their mail for them
- have some personal http space where they can put bulky info the lists
won't accept

For the average bug reporter it's a very hostile system. Most people
don't have any of this, that's what bugzilla provides (and of course if
you have your own personnal infrastructure bugzilla may seem
unnecessary)

Don't get me wrong I had bugs solved through e-mail (or irc), and I had
bugs solved through bugzilla, and every time having a motivated fixer
and a good bug report was more important than the method used. These
days I only report through bugzilla because it makes it easier to attach
stuff and create good reports.

Now, the critical part on any bug reporting system is people like
Adrian. You can have reporter-oriented systems (bugzilla) or
developer-oriented systems (e-mail) what makes them work are the
go-betweens (who happen to do the less sexy and hardest part of the
process). They're the ones who mediate between:
1. reporters who just want to report a problem without spending a month
learning the habits of the people in charge of the code
2. developers who want gold-plated reports

So IMHO:

1. people like Adrian should be the ones choosing the reporting method
so it makes *their* job not the reporter or developer ones easier

2. when they bend backwards to send reports in the developer-preferred
form (like Adrian did) it's criminal to ignore them like a random e-mail
or bugzilla report. The bug may be more work than the technical problem
is worth but that's not the point. People like Adrian are not
replaceable. When they've invested so much time producing nice reports
you have to act on them if only to mark your respect for people doing a
thankless but necessary job.

-- 
Nicolas Mailhot
