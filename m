Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXJ1THV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXJ1THV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ1THH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:07:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:37490 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXJ1THE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=e2QdBZ/Aq56I0jiO5JBem6Z1nAifE5KO32TwkDyJvtiJ23RUXt3QkSnaFrrBpAtFdMFAKv41QKpN8plHW3gmC1zEa+Jbac+c4hs9id/1XtXNvlRbzA/zHtGzqNUyMh7iNdwi21uNPVDhpjFoWcqhK6AWBm718Am7pjYyeoKsx/A=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Pavel Machek'" <pavel@ucw.cz>, "'Ray Lee'" <ray-lk@madrabbit.org>
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Chris Wright'" <chrisw@sous-sol.org>,
       "'Casey Schaufler'" <casey@schaufler-ca.com>,
       "'Adrian Bunk'" <bunk@kernel.org>, "'Simon Arlott'" <simon@fire.lp0.eu>,
       <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
       "'Jan Engelhardt'" <jengelh@computergmbh.de>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Andreas Gruenbacher'" <agruen@suse.de>,
       "'Thomas Fricaccia'" <thomas_fricacci@yahoo.com>,
       "'Jeremy Fitzhardinge'" <jeremy@goop.org>,
       "'James Morris'" <jmorris@namei.org>,
       "'Crispin Cowan'" <crispin@crispincowan.com>,
       "'Giacomo Catenazzi'" <cate@debian.org>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com> <20071025002356.GB3660@sequoia.sous-sol.org> <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com> <20071025024131.6082e4a8@the-village.bc.nu> <2c0942db0710251117k37c30b2ex5cc6d8cd8c9ea029@mail.gmail.com> <20071027182911.GD4159@ucw.cz>
In-Reply-To: <20071027182911.GD4159@ucw.cz>
Subject: RE: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Date: Sun, 28 Oct 2007 12:05:46 -0700
Message-ID: <008601c81995$90670030$b1350090$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcgZjlwFpFPt2li5SpKpcqUD1itVswABNHPw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think you may be misinterpreting the word "poor" here.

Many people in this thread consider a security solution "poor" because it's
not "complete" or "perfect": it may work against attack ABC but not attack
XYZ. The defendants say that XYZ isn't possible in the environment that it's
supposed to be used, or XYZ may be too expensive to be worth implementing,
or they just are rare enough to be ignored. Heck, all security solutions
could be broke given physical access.

Implementing a security solution has a cost. Bypassing it also has a cost.
Sometimes it's economy, not technique, decides whether a particular security
solution is a good one.

Locks are a good example for this. It has a low cost/effect ratio, and very
easy to use. Is it 100% safe? Definitely not. People lock their bikes to a
tree when they enter a supermarket because it's reasonably safe. But leaving
their bikes like that over a few nights on a downtown street? Probably not a
good idea. Don't assume all people are idiots who do not know that (ok, some
people are, so the lock's manual states "it can be bypassed by a skilled
thief").

But what tapes are good for? I don't know what kind of value it adds to the
discussion.

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Pavel Machek
> Sent: Saturday, October 27, 2007 11:29 AM
> To: Ray Lee
> Cc: Alan Cox; Chris Wright; Casey Schaufler; Adrian Bunk; Simon Arlott;
> linux-kernel@vger.kernel.org; linux-security-module@vger.kernel.org;
> Jan Engelhardt; Linus Torvalds; Andreas Gruenbacher; Thomas Fricaccia;
> Jeremy Fitzhardinge; James Morris; Crispin Cowan; Giacomo Catenazzi
> Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
> static interface)
> 
> Hi!
> 
> > > > The idea that poor security is worse than no security is
> fallacious,
> > > > and not backed up by common experience.
> > >
> > > There is a ton of evidence both in computing and outside of it
> which
> > > shows that poor security can be very much worse than no security at
> all.
> >
> > (So, I take it that you *don't* lock your bike up, as poor security
> is
> > worse than none?)
> 
> I do lock my bike with combination lock I found somewhere and cracked
> in five minutes... sometimes.
> 
> But do you suggest that I use paper tape to 'lock' my bike to
> streetlight? You just said that poor security is better than none,
> right?
> 
> 							Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

