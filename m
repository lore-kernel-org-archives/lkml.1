Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXJ1BUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXJ1BUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 21:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXJ1BUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 21:20:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46150 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492AbXJ1BUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 21:20:41 -0400
Date: Sun, 28 Oct 2007 02:21:01 +0100
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
Subject: Re: eradicating out of tree modules (was: Linux Security *Module*
	Framework)
Message-ID: <20071028012101.GD23339@stusta.de>
References: <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026155833.GF23016@kroah.com> <4723462D.2010002@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4723462D.2010002@imap.cc>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 04:07:41PM +0200, Tilman Schmidt wrote:
> Greg KH schrieb:
> > On Fri, Oct 26, 2007 at 11:46:39AM +0200, Tilman Schmidt wrote:
> >> [...] I still think there will always be
> >> a number of external modules that cannot be merged right now or at
> >> all, and deliberately making life difficult for out-of-tree code
> >> maintainers in order to coerce them into submitting their code for
> >> inclusion in the kernel will not work, it'll only create bad
> >> feelings.
> > 
> > Do you have examples of proof of this?
> 
> No proof in the legal, mathematical or scientific sense of the
> term, but examples:
> 
> - at least one talented kernel developer giving up his work,
> until then maintained out of tree, after submitting it for
> inclusion in the kernel and taking the ensuing fla^Wdiscussion
> on LKML (nothing extraordinary, just the usual lack of
> courtesy and respect) too much to heart
>...

There's one important point to note:

In a project of the size of the Linux kernel (at about 2000 distinct 
people contributing code within one year) you will always lose 
developers:

If you require too much from code for getting it included you lose some 
of the people who develop code.

If you accept code of dubious quality you lose some of the people who 
care about the quality of the kernel.

And if you add a stable API for modules with not GPL compatible licences 
at least one untalented kernel developer (me) might give up his work.

If your goal is to please all developers you have a goal you can't 
achieve.

The only reasonable way is to accept that whatever you do you'll lose 
some people and go in the direction you consider the right one.

And the power of open source is that when an open source project gets 
into a direction many people dislike they can simply fork it. Consider 
e.g. XFree86->X.Org or NetBSD->OpenBSD. And that's nothing bad - either 
the forks develop in different directions creating different useful 
software or there's an evolutionary contest for the best software.

> T.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

