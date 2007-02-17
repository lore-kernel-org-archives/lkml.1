Return-Path: <linux-kernel-owner+w=401wt.eu-S2992847AbXBQR2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992847AbXBQR2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992848AbXBQR2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 12:28:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:48656 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992847AbXBQR2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 12:28:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AvrNZ3N7hmAOzsJURAtV8foyKk+FV5bPYio7xyrNbtgAqCussUnZogB5tQlJanp2FkNYg7QndLA7VzyxZaL5GISvW50ZDiV08pxpF9ayxA1yGTkIT3x12/ZaSgSkOWzrel2BMfrFo6ykEZQgmcqnqcM124tmBFgZzxgLeKthjHE=
Message-ID: <b14e81f00702170928y5c2d3e2es14917c93049064e8@mail.gmail.com>
Date: Sat, 17 Feb 2007 12:28:43 -0500
From: "michael chang" <thenewme91@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] Re: 2.6.20-ck1
Cc: "ck mailing list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200702171417.28376.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702162110.03355.kernel@kolivas.org>
	 <200702171213.40718.kernel@kolivas.org>
	 <b14e81f00702161815x13c25936r49f540beeda3e334@mail.gmail.com>
	 <200702171417.28376.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> On Saturday 17 February 2007 13:15, michael chang wrote:
> > On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> > > I'm thru with bashing my head against the wall.
> >
> > I do hope this post isn't in any way redundant, but from what I can
> > see, this has never been suggested... (someone please do enlighten me
> > if I'm wrong.)
> >
> > Has anyone tried booting a kernel with the various patches in question
> > with a mem=###M boot flag (maybe mem=96M or some other "insanely low
> > number" ?) to make the kernel think it has less memory than is
> > physically available (and then compare to vanilla with the same
> > flags)? It might more clearly demonstrate the effects of Con's patches
> > when the kernel thinks (or knows) it has relatively little memory
> > (since many critics, from what I can tell, have quite a bit of memory
> > on their systems for their workloads).
> >
> > Just my two cents.
>
> Oh that's not a bad idea of course. I've been testing it like that for ages,

It never hurts to point out the obvious in case someone didn't notice,
so long as one doesn't become repetitive.

> and there are many -ck users who have testified to swap prefetch helping in
> low memory situations for real as well. Now how do you turn those testimonies
> into convincing arguments? Maintainers are far too busy off testing code for
> 16+ cpus, petabytes of disk storage and so on to try it for themselves.  Plus

Pity. What about virtualization? Surely one of these 16+ CPU machines
with petabytes of disk storage can spare one CPU for an hour for a
virtual machine, just set it with like a 3 GB hard drive image (which
is later deleted), 1 GB swap (ditto), 128 MB memory, and one CPU
instance -- then test with vanilla and the patches in question? (My
understanding is that one of the major "fun things" that these kinds
of machines have is that they come with interesting VM features and
instruction sets.)

> they worry incessantly that my patches may harm those precious machines'
> performance...

Has anyone tested it on one of these massive multi-core "beasts" and
seen if it DOES degrade performance? I want to see numbers. Since the
performance improvements for these machines are based on numbers, I
want to see any argument for degradation also in numbers. Both
absolute numbers and relative numbers.

(Obviously, since -ck doesn't target that kind of thing, it's not
possible at the moment to prove how useful -ck is with numbers. But
surely we can measure how much of a "negative" impact it does have on
everything else. If it isn't hurting anyone, then what's wrong with
it?)

Unfortunately, the argument that "xyz" is just as bad/worse is hardly
useful from what I've seen in kernel talks... maybe we're missing
something here.

Is it possible to command a program's memory usage be put into swap on
purpose, without "forcing" it into swap by taking other memory? (Maybe
such a feature could be used to time how long it takes to restore from
swap by timing how long the first or second display update takes on
some typically-used GUI program that takes a while to draw its GUI.)

Just a couple of additional thoughts.

> --
> -ck
>

-- 
~Mike
 - Just the crazy copy cat.

P.S. For anyone who cares and is sending replies to my messages, I am
subscribed to the ck ML, but not linux-kernel. So if you want me to
see it and it's in the latter, CC me.
