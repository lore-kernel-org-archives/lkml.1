Return-Path: <linux-kernel-owner+w=401wt.eu-S1764555AbXEZVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764555AbXEZVsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 17:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbXEZVsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 17:48:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbXEZVsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 17:48:30 -0400
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
From: Dan Williams <dcbw@redhat.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Michael Buesch <mb@bu3sch.de>, Larry Finger <larry.finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200705262332.50640.uwe.bugla@gmx.de>
References: <20070524195616.234280@gmx.net>
	 <200705262139.54353.uwe.bugla@gmx.de> <200705262149.09948.mb@bu3sch.de>
	 <200705262332.50640.uwe.bugla@gmx.de>
Content-Type: text/plain
Date: Sat, 26 May 2007 17:52:31 -0400
Message-Id: <1180216351.24168.7.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-26 at 23:32 +0200, Uwe Bugla wrote:
> Am Samstag, 26. Mai 2007 21:49 schrieben Sie:
> > On Saturday 26 May 2007 21:39:54 Uwe Bugla wrote:
> > > Am Samstag, 26. Mai 2007 21:19 schrieben Sie:
> > > > Uwe, please try the following patch:
> > > >
> > > > Index: bu3sch-wireless-dev/drivers/net/b44.c
> > > > ===================================================================
> > > > --- bu3sch-wireless-dev.orig/drivers/net/b44.c	2007-05-18
> > > > 18:09:50.000000000 +0200 +++
> > > > bu3sch-wireless-dev/drivers/net/b44.c	2007-05-26 21:18:28.000000000
> > > > +0200 @@ -2201,10 +2201,12 @@ static int __devinit b44_init_one(struct
> > > > printk("%2.2x%c", dev->dev_addr[i],
> > > >  		       i == 5 ? '\n' : ':');
> > > >
> > > > +#if 0
> > > >  	/* Initialize phy */
> > > >  	spin_lock_irq(&bp->lock);
> > > >  	b44_chip_reset(bp);
> > > >  	spin_unlock_irq(&bp->lock);
> > > > +#endif
> > > >
> > > >  	return 0;
> > >
> > > Against what kernel please?
> > > Just try to be a bit more eloquent, man!
> >
> > Against a kernel which does not work for you, of course.
> >
> > Sometimes I wonder... (no better not say that).
> 
> YES! And I wonder TOO, definitely!
> 
> Quand meme (now, if you do not speak french: Above all that), I applied your 
> patch against 2.6.22-rc2-mm1. Just to show my cooperation willing to get 
> your "dream" being fulfilled!
> 
> Result is: No change!
> Non-functionable b44-device at all!
> 
> Hint: Although being a "non-hacker" or "non-developer" I do have stepped 
> across some experienced developer people who at least added some code to make 
> their modules function in the following way:
> 
> modprobe xyz debug=1 (or debug=2 or debug=3 or debug=4 or debug=5 or debug=6)
> 
> In so far, if you continue to state that debugging is nothing but guessing 
> around wildly you are definitely wrong, showing us all your missing code 
> hacker experience. If you DO continue like this every step will be a torture 
> not only for me but for the reading folks as well.
> 
> But every human being is here to learn and develop: In so far I am very 
> optimistic!
> 
> Apart from the Kconfig chaos that seems to be subordinate in your personal 
> rating scale, you at least could have added some functions like the above 
> mentioned functions.
> 
> The fact that you simply ignored to imply those functions and continue to call 
> other people dumb shows exactly how small and humble you are.
> 
> Apart from that:
> The message that you rooted to my place was no "proof" at all for any kind of 
> disfunctionality or compatibility issue!
> 
> In that message the lack of performance of the "enclosed" or "old" 
> or "complete" b44 module (i. e. PCI-only module) was criticised, NOT the one 
> ripped by you personally into two modules called b44 and ssb.
> 
> In so far I would deeply appreciate you personally to stick to the facts in 
> your personal lack of knowledge about the b44 driver instead of playing bad 
> politics against other people like me and others.
> 
> 
> Hello my dear Andrew Morton,
> 
> Could you please do me and the rest of the world two favours?
> 
> A. Rip Michael Buesches code out of the mm-tree
> 
> B. Give Michael Buesch a fair chance to revise his disfunctionable code 
> outside the mm-tree and / or the vanilla mainline.
> 
> Side note for the what and why:
> 
> I like to help avoid dangers by testing the mm-tree.
> BUT:
> 
> If real debugging conforms to nothing but guessing around wildly let me tell 
> you that I do not appreciate to be part of that torture due to the lack of 
> experience of some German spare time hacker.
> 
> A: proven by facts not knowing or even wanting to know how to imply 
> appropriate functionable debug parametres in his driver code
> 
> B: non-cooperative as far as Kconfig help features are concerned (i. E. help 
> to understand the issues for users
> 
> C: calling all people simply dumb who do not know about his personal issues at 
> all
> 
> Thank you, Andrew Morton! You are real fine!

Everyone just needs to cool down.  And you both (Uwe and Michael) just
need to try debugging the problem.

Abstracting the SSB code into a library is clearly the correct solution,
rather than having the same code in two separate places.  The whole
_point_ of having code in various trees (wireless, mm, etc) is to find
these bugs before the patches hit mainline.  Even testing on > 3
machines may not uncover subtle bugs (for example, different behavior on
different silicon revisions, especially in reverse-engineered parts),
it's only something Michael can test so far before other people have to
pick it up and test it.  And that's where you come in, Uwe.

So both of you should actually just stop the name-calling, suck it up,
and debug the problem.  We're getting nothing done here.

Dan

> Sincerely
> 
> Uwe
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

