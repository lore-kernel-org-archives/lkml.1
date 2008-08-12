Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYHLS74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYHLS74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHLS7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:59:49 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:33787 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751357AbYHLS7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:59:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=CCbdOBp2hbeDb0BhzCV+mwH7ZquuZE0yMzoOK25GIkEpr6XN5Ff2pSLxAAfnDdA1Yfada86SEsF+VfF4P9oGjlX2ukDC2zzNE+flyRw/b0mI1SHyCUo+rI/verKCnpqUsbMUYUumoB4rxepxJ67YP9zEoFxFX4gSJOgCXtJfJ1w=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 12 Aug 2008 11:59:48 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- RCU problem
To: Ray Lee <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <311058.45973.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Since this _feels_ like my problem alone, then it _feels_ like I
> > should have to be the one to fix it.
> 
> Hard data first, and then there will be plenty of time for blame
> later. Not that there's any real blame for anyone here, we just have a
> bug that needs to be found and fixed.

I didn't come here seeking to blame, I came here to help find the bug...
if there is a bug, instead of just bad hardware....  but 2.6.25 worked
just fine....  <*scratches head*>

Actually, I used to blames Gates for everything.  Now I just blame
Torvalds for everything.  He's the one who started all of this mess....


> Finding the problem is over half the battle, so you *are* doing something.

Thx.

I had a secondary agenda, though:  I use Debian, and they are talking about
using 2.6.26 in their upcoming stable release.  So, if there _is_ a bug, I
hoped to see it released before that.  They're talking about Sep. or Oct.
(Heh... Debian NEVER releases on-schedule, so there's plenty of time! ;)


> His commit may have uncovered a latent problem somewhere else, that
> happens often. But if the commit really is the trouble one, then two
> things happen: It's rc3 or rc4 now, so we just revert the damn thing,
> and then (secondly) he works with you (by adding debugging or
> whatever) to figure out where the problem actually is.

Well, I'm not asking for a revert.  I'm not really asking for anything,
just passing along information, but I would like to make myself and my
machine available for anyone who does kernel work to do experiments,
tests, debugging, patches, or whatever.


> The point I'm trying to make here is when you take on too much for
> yourself, then it slows down debugging the problem, and means whatever
> issue is in the code will be in there longer, affecting more people.

OK.  Well, I certainly don't want to interfere.  I guess I wasn't really
conscious that I was slowing people down.  It's very likely that I don't
understand the process here, especially what my role should be -- since
I am not a developer, but I seem to be the only one with hardware that
exhibits the problem.


> > Or on anyone's machine on LKML?
> > These kernels even work on one of my machines!  So it's not clear that
> > Yinghai's commit is to blame:  maybe it is, maybe it isn't.  All that
> > we know is that commit triggered the problem, and we don't even know
> > whether the problem will affect a lot of hardware or just mine!
> 
> Yes, all of that is true, but changes nothing.

Well, I don't think the purpose of my response was to "change" anything,
but simply to point out my (possibly false) assumption that it will be
difficult or impossible to find the bug, or the broken hardware, on
machines where the kernel does not freeze.  Sometimes people overlook
obvious things, so the purpose of my post which you were responding to
was to make a second pass over potentially obvious things -- especially
for the sake of those who were not being CC'd since the beginning of the
thread 8 days ago.  If you look back over the history of this thread, 
you'll see that I was asked to provide information that had already been
provided -- which I was glad to do, but which made me wonder whether some
of the latecomers might notice something important in the posts they had
not seen.


> > I'll really feel better if the reverting experiment works.
> 
> Good luck.

Working on it now.  I changed my mind, though:  even if the reverted kernel
does compile and run, I still won't feel better.  I have become curious
about why that commits works on all the machines except 2 of mine.
Reverting means we may never know... which would be an unbearable conclusion
for an obsessed mind like my own!  ;)


Thanks,
Dave W.
