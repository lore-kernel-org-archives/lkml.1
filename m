Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbXE0KrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbXE0KrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXE0Kq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:46:56 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:37143 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXE0Kqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:46:54 -0400
Date: Sun, 27 May 2007 12:46:51 +0200
Message-Id: <97963914@web.de>
MIME-Version: 1.0
From: Uwe Bugla <Watzmann@web.de>
To: Dan Williams <dcbw@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Larry Finger <larry.finger@lwfinger.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+FOMseoOV8JSOimYGi5k+kLSVWbk+sdoxy5FND3LxTSGs60
 C19QqQYzNq390djwuqQNmtaiBqQrp51z2VSL0E6MwVl+k5a6Ko=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 26. Mai 2007 23:52 schrieben Sie:
> On Sat, 2007-05-26 at 23:32 +0200, Uwe Bugla wrote:
> > Am Samstag, 26. Mai 2007 21:49 schrieben Sie:
> > > On Saturday 26 May 2007 21:39:54 Uwe Bugla wrote:
> > > > Am Samstag, 26. Mai 2007 21:19 schrieben Sie:
> > > > > Uwe, please try the following patch:
> > > > >
> > > > > Index: bu3sch-wireless-dev/drivers/net/b44.c
> > > > > ===================================================================
> > > > > --- bu3sch-wireless-dev.orig/drivers/net/b44.c        2007-05-18
> > > > > 18:09:50.000000000 +0200 +++
> > > > > bu3sch-wireless-dev/drivers/net/b44.c 2007-05-26 21:18:28.000000000
> > > > > +0200 @@ -2201,10 +2201,12 @@ static int __devinit
> > > > > b44_init_one(struct printk("%2.2x%c", dev->dev_addr[i],
> > > > >                      i == 5 ? '\n' : ':');
> > > > >
> > > > > +#if 0
> > > > >       /* Initialize phy */
> > > > >       spin_lock_irq(&bp->lock);
> > > > >       b44_chip_reset(bp);
> > > > >       spin_unlock_irq(&bp->lock);
> > > > > +#endif
> > > > >
> > > > >       return 0;
> > > >
> > > > Against what kernel please?
> > > > Just try to be a bit more eloquent, man!
> > >
> > > Against a kernel which does not work for you, of course.
> > >
> > > Sometimes I wonder... (no better not say that).
> >
> > YES! And I wonder TOO, definitely!
> >
> > Quand meme (now, if you do not speak french: Above all that), I applied
> > your patch against 2.6.22-rc2-mm1. Just to show my cooperation willing to
> > get your "dream" being fulfilled!
> >
> > Result is: No change!
> > Non-functionable b44-device at all!
> >
> > Hint: Although being a "non-hacker" or "non-developer" I do have stepped
> > across some experienced developer people who at least added some code to
> > make their modules function in the following way:
> >
> > modprobe xyz debug=1 (or debug=2 or debug=3 or debug=4 or debug=5 or
> > debug=6)
> >
> > In so far, if you continue to state that debugging is nothing but
> > guessing around wildly you are definitely wrong, showing us all your
> > missing code hacker experience. If you DO continue like this every step
> > will be a torture not only for me but for the reading folks as well.
> >
> > But every human being is here to learn and develop: In so far I am very
> > optimistic!
> >
> > Apart from the Kconfig chaos that seems to be subordinate in your
> > personal rating scale, you at least could have added some functions like
> > the above mentioned functions.
> >
> > The fact that you simply ignored to imply those functions and continue to
> > call other people dumb shows exactly how small and humble you are.
> >
> > Apart from that:
> > The message that you rooted to my place was no "proof" at all for any
> > kind of disfunctionality or compatibility issue!
> >
> > In that message the lack of performance of the "enclosed" or "old"
> > or "complete" b44 module (i. e. PCI-only module) was criticised, NOT the
> > one ripped by you personally into two modules called b44 and ssb.
> >
> > In so far I would deeply appreciate you personally to stick to the facts
> > in your personal lack of knowledge about the b44 driver instead of
> > playing bad politics against other people like me and others.
> >
> >
> > Hello my dear Andrew Morton,
> >
> > Could you please do me and the rest of the world two favours?
> >
> > A. Rip Michael Buesches code out of the mm-tree
> >
> > B. Give Michael Buesch a fair chance to revise his disfunctionable code
> > outside the mm-tree and / or the vanilla mainline.
> >
> > Side note for the what and why:
> >
> > I like to help avoid dangers by testing the mm-tree.
> > BUT:
> >
> > If real debugging conforms to nothing but guessing around wildly let me
> > tell you that I do not appreciate to be part of that torture due to the
> > lack of experience of some German spare time hacker.
> >
> > A: proven by facts not knowing or even wanting to know how to imply
> > appropriate functionable debug parametres in his driver code
> >
> > B: non-cooperative as far as Kconfig help features are concerned (i. E.
> > help to understand the issues for users
> >
> > C: calling all people simply dumb who do not know about his personal
> > issues at all
> >
> > Thank you, Andrew Morton! You are real fine!
>
> Everyone just needs to cool down.  And you both (Uwe and Michael) just
> need to try debugging the problem.
>
> Abstracting the SSB code into a library is clearly the correct solution,
> rather than having the same code in two separate places.  The whole
> _point_ of having code in various trees (wireless, mm, etc) is to find
> these bugs before the patches hit mainline.  Even testing on > 3
> machines may not uncover subtle bugs (for example, different behavior on
> different silicon revisions, especially in reverse-engineered parts),

yes, and to simplify that you need additional commandline parametres 
(debug=1,2,3,4,5 f. ex.).
Those debug levels provide:
1. different verbose levels of printed output, sent to specific logs like 
kern.log for example
2. different hexadecimal outprints who show what sub-part of the driver is 
working as expected and what part is not
3. if the driver is loaded correctly but refuses to work as expected while 
the "traditional" one without "outsourced" ssb backplane works as expected 
there must be some technique to move the what and why into system logs, just 
to establish facts instead of guessing around.
4. If that technique is not provided by the author of the code then that is a 
proof for the author's lack of experience. As I said already: Too many cooks 
do spoil the pap.

If debugging is limited to dmesg, .config and guessing around, then I call 
such a code a real poor and crude one.

> it's only something Michael can test so far before other people have to
> pick it up and test it.

Theoretically: yes. Practically: No, due to the personal withdraws of the 
latest cook.

Michael in fact thinks that if he is producing code he can delegate everything 
else to other people, replying "for me it works" like a parrot.

In so far, not only the code itself is quite rude and crude, but the author of 
the code is too, transforming the testing procedure into a torture due to the 
author's (i. e. the latest cook's) proven personal and technical 
incompetence. 

> And that's where you come in, Uwe. 

Yes.

>
> So both of you should actually just stop the name-calling, suck it up,
> and debug the problem.  We're getting nothing done here.
>
> Dan

You cannot debug the problem for the reasons that I already described, and I 
will not spend my time with this crude stuff anymore.

My proposal is: Gary Zambrowski should revise that code (the only one Cced 
being employed at broadcom.com, the manufacturer).

Until the job is done by Gary Andrew Morton should rip this stuff out of the 
mm-tree for being rude, crude, immature.

Uwe

_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

