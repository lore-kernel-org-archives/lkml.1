Return-Path: <linux-kernel-owner+w=401wt.eu-S964873AbXBYOWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873AbXBYOWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 09:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964878AbXBYOWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 09:22:00 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:23651 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964873AbXBYOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 09:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XM9UQoacB2AsFXlrcFI9dWuhP4y/NEsdfSCkZXi8VTsi6QdTaVBTZ8IyLT/Plsx3ObVGRzDqmj4rz7SozdHPuoVE/O/IqWDMPj4luwVoSuRi9gF02cpkUZ9Abl3oMk/dXW7GlWoju0djGJDK7AC4wFiMEuA2iJIPQa7W2qfVi4I=
Message-ID: <f2b55d220702250621h1877f8e8x19293cc8b95bf56@mail.gmail.com>
Date: Sun, 25 Feb 2007 06:21:57 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Pavel Machek" <pavel@ucw.cz>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <20070225135208.6e2eab9c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	 <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
	 <20070225104211.GB2045@elf.ucw.cz>
	 <f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
	 <20070225135208.6e2eab9c@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > of other places too.  Especially when the graphics chip maker explains
> > that keeping their driver source code closed isn't really an attempt
> > to hide their knowledge under a bushel basket.  It's a defensive
> > measure against having their retail margins destroyed by nitwits who
> > take out all the busy-wait loops and recompile with -O9 to get another
> > tenth of a frame per second, and then pretend ignorance when
> > attempting to return their slagged GPU at Fry's.
>
> Wrong as usual...

If this is an error, it's the first one _you've_ caught me in.  Or did
I miss something conformant to external reality in your earlier
critiques?

> The Nvidia driver and ATI drivers aren't full of magical delay loops and
> if there was a way to fry those cards easily in hardware the virus folks
> would already be doing it. The reverse engineering teams know what is in
> the existing code thank you. Creating new open source drivers from it is
> however hard because of all the corner cases.

Several years ago I worked on a MIPS-based set-top prototype mated to
a graphics+HDTV board from a major PC 3-D vendor.  We had full
documentation and a fair amount of sample code under NDA.  We were on
the vendor's board spin 52 -- 52! and they'd sometimes spun the chip a
couple times internally between released boards -- before it could be
persuaded to do the documented thing with regard to video textures.
In the meantime, we frotzed a lot of boards and chips before we
decided to stick a triple-size fan to the damn thing with thermal
grease and to avoid taking any chances with new VRAM timings except in
the oversized chassis with the jet-engine fans.  Maybe things have
gotten better since then, but I doubt it.

Busy-wait loops were a rhetorical flourish, I grant you.  But software
interlocks on data movement that protect you against some "corner
case" you're unlikely to think of on your own are the norm, as is
software-assisted clock scaling guided by temperature sensors in half
a dozen places on chip and package.  You can drive enough watts
through a laptop GPU to fry an egg on it -- which is not kind to the
BGA bonds.  Yes, I have killed a laptop this way -- one that's
notorious for popping its GPU, but it's no accident that the last
thing I did to it was run a game demo that let me push my luck on the
texture quality.

It's also quite common, or used to be, for the enforcement of limits
on monitor sync timings to be done in software, and it's quite
possible to kill an underdesigned monitor or grossly exceed regulatory
emissions limits by overdriving its resolution and frame rate.  (I've
never actually blown one up myself, but I've pushed my luck
overdriving a laptop dock's DVI and gotten some lovely on-screen
sparklies and enough ultrasonics to set the neighbor's dog to
whining.)  Viruses that kill your monitor may be urban legend, but
it's a can of worms that a smart graphics vendor doesn't want to be
liable for opening.  The FCC also frowns on making it too easy for
hobbyists to turn a Class B device into a two-block-radius FM jammer.

> You will instead find that both vendors stopping providing Linux related
> source code at about the point they got Xbox related contracts. A matter
> which has been pointed out to various competition and legal authorities
> and for now where it seems to lie.

I know it's fun to blame everything on Redmond, but how about a
simpler explanation?  The technology and market for 3-D graphics is
now sufficiently mature to allow revenue maximization through market
segmentation -- in other words, charging some people more than others
for the same thing because they're willing and able to pay extra.  The
volumes are also high enough to test chips as they come out of fab and
bin them by maximum usable clock speed, just like Intel has done with
its CPUs for the last decade.  Blow a couple of dozen fuses to set a
chip ID, laser trim a couple of resistors to set a default clock
multiplier, and sell one for ten times what you get for the other.
It's the only way to survive in a mature competitive environment.

Now, suppose the silicon process for GPUs has stabilized to where chip
yields have greatly improved, and maybe 80% of the chips that work at
all are good enough to go in any but the top-of-the-line gamer
specials.  So where do they get the chips for a motherboard that sells
for $69 at Fry's?  They artificially bin them by target spec, blow
those fuses and trim those resistors, and charge what the market will
bear, niche by niche.  The driver picks up on the chip ID and limits
its in-system performance to the advertised spec, and everyone goes
home happy.

The graphics chip vendors are not utterly stupid.  They have seen what
has happened to the retail distribution of x86 CPUs, in which
overclocker types take six mid-range chips home, see which one they
can clock into the stratosphere for 24 hours without actually setting
the motherboard on fire (they don't mind a little toxic outgassing
from the thermal grease), and return the other five, not visibly the
worse for wear.  (Yes, I know people who have done this.)  They are
not about to hand their own heads to you on a silver platter along
with the source code that implements their market segmentation -- and
I, for one, don't blame 'em.

You go on believing that the X-Box contracts say "don't let Alan see
your source code any more".  Or if you prefer, believe that ATI and
NVidia don't know everything there is to know about each other's
external interfaces, or that they fear their source code will help
some VLSI sweatshop in Nowheristan clone chips that are protected by
hundreds of patents and are way more complicated inside than the
average CPU.  Because we all know how big the market for first-person
shooters is in the places in central Asia where patents can't reach.
Me, I'm going to stick to the explanation that's staring me in the
face when I read the annual reports.

> Fortunately at the moment there is a simple cure - buy Intel hardware.
> That also has the advantage that you are more likely to get help because
> some of us only look at AMD processor related problems as part of
> official work duties nowdays, and plan to do so until AMD (as owner
> of ATI) behave.

Taking your marbles and going home?  Now _there's_ a way to win
friends and influence people.  Personally, I don't exactly buy AMD or
Intel for desktop use; I buy a complete, working system that I'm never
going to be tempted to crack open and find out what's in it.  In
recent years that has meant Macs at home and whatever IT gave me at
work (preferably a craptop with lots of dots; I promise not to fry
them with game demos in the future).  And I certainly don't look at
processor related problems on my own time -- my hobbies are choral
singing and my rose garden.  Guess which one of us is a better
predictor of future market trends?

Cheers,
- Michael
