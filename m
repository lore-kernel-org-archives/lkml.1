Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbXK0Wxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbXK0Wxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXK0Wxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:53:47 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57467 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752777AbXK0Wxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:53:46 -0500
Date: Tue, 27 Nov 2007 23:53:34 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071127225334.GI3406@stusta.de>
References: <20071125172237.GC6658@kernel.dk> <20071127070912.GB1735@ff.dom.local> <20071127164723.GA3406@stusta.de> <474C9714.1080308@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <474C9714.1080308@o2.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 11:15:48PM +0100, Jarek Poplawski wrote:
> Adrian Bunk wrote, On 11/27/2007 05:47 PM:
> 
> > On Tue, Nov 27, 2007 at 08:09:12AM +0100, Jarek Poplawski wrote:
> >> On 25-11-2007 18:22, Jens Axboe wrote:
> >>> On Sun, Nov 25 2007, Adrian Bunk wrote:
> >> ...
> >>>> Is there any technical reason why we need 4 different schedulers at all?
> >>> Until we have the perfect scheduler :-)
> >> IMHO this is not enough yet. There is something called "the right
> >> of choice",
> > 
> > That's a common misconception about open source software:
> > 
> > There is nothing like a "right of choice".
> > There is a "right to change the source code".
> 
> Maybe you are right, maybe I've used wrong words... But, e.g., google
> pretends to know about this first right too. And I've meant generally,
> not about open software.

Most Google hits are about abortion.

The fact that people use this term in some completely different 
context does not give it the meaning you implied it had.

Oh, and this right of choice also does not exist in Poland...

> > This means you cannot demand from anyone to offer any choices, but you 
> > can fork the code yourself and use and distribute modified code 
> > containing any choices you consider reasonable.
> 
> I don't demand anything. I've only expressed my personal opinion
> that usually (if possible) the choice is better than no choice.

And I'm trying to explain why your personal opinion is wrong in many 
cases.

> And, since I don't know anything in open source forbiding this, I
> can ask, why you demand to take away offered choices; actually, I
> think it would be much easier if you could fork the other way...

There's nothing forbiding this, it's simply the question what results in 
a better kernel (see below).

> >> and, it seems, things are usually far from perfect
> >> where this right is not respected.
> > 
> > That's wrong.
> > 
> > It's actually often much worse to have different choices with different 
> > features and bugfixes than having one version that contains all features 
> > and all bugfixes.
> 
> It's only a part of the theory: usually it's easier to find some bugs
> if there is a possibility to compare a performance with other options;
> there is also kind of stimulation and flow of new ideas between them.
> Otherwise it's not so hard to overlook some stagnation.

Let's leave the theory.

As one of the most active code removers in the kernel [1], I can tell 
you what actually happens in practice:

Given:
- two choices A and B
- user tried choice A and it has a problem (e.g. doesn't work or has
  bad performance)

What happens:
- if choice B works, user uses choice B

What happens without choice B:
- user reports the problem and choice A gets fixed

It's always surprising how many people complain when you deprecate or 
remove a choice B that choice A wouldn't work for them, and who had 
never reported their problems before since choice B worked for them...

> Regards,
> Jarek P.

cu
Adrian

[1] http://lwn.net/Articles/247582/

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

