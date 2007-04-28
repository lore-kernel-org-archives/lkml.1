Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbXD1MvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbXD1MvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 08:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXD1MvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 08:51:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:22449 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbXD1MvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 08:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OedVDpb8nK2ykh0whDKwYuagbbE98GH3crAvxf8fcKN6nxQoZs8kGFY/Ab9MbD65IRlzgYjEuAMKeVB8IjxfGPB0WrjAG5n1+rEPqbeQaBfemHdO89CcKJDi03Pj9ZrwX2W2nNcbkaDa6NDXvypKqHuY4aOlKPmkfNPsxlqxkAM=
Message-ID: <d9def9db0704280551t27e8fdd6sfd26af35915ca86a@mail.gmail.com>
Date: Sat, 28 Apr 2007 14:51:19 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: Linux 2.6.21
Cc: "Theodore Tso" <tytso@mit.edu>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070427194605.GV3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
	 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	 <20070426165950.GO3468@stusta.de>
	 <20070426215015.003f6196@the-village.bc.nu>
	 <20070427145805.GT3468@stusta.de> <20070427163143.GG24852@thunk.org>
	 <20070427194605.GV3468@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Fri, Apr 27, 2007 at 12:31:43PM -0400, Theodore Tso wrote:
> > On Fri, Apr 27, 2007 at 04:58:05PM +0200, Adrian Bunk wrote:
> > > "no regressions" is definitely not feasible.
> > >
> > > 14 known regressions, some of them not yet debugged at all, are
> > > different from your "some small regression".
> >
> > Yes, but when were some of these regressions reported?  Past a certain
> > point, I think it's reasonable to look at the regression, decide how
> > many people would be affected by it, and why it hadn't been noticed
> > earlier, and in some cases, decide that it's better to get this
> > debugged and fixed in the stable and development trees in parallel.
>
> 8 of them have been reported in March or earlier. [1]
>
> Patches for 2 of these 8 were available at the time of the release. [2]
> While the question whether to merge one of them into 2.6.21 was
> controversial, the other one was not controversial.
>

I can imagine that the dvb oops bugfix got held back to avoid some
noise with dvb developers who claimed that they didn't get notified
about how that patch got into the v4l-dvb repository (it didn't get
reviewed by these people for weeks because it simply got ignored and
some of them were aware of that)

On the other side if I read bugreports like the following one:
http://www.mail-archive.com/linux-dvb%40linuxtv.org/msg23028.html

(My Nova-T 500 crashes quite regularly. My machine has been running for
about a week and in that time has had 5 oopses.)

It doesn't solve the Nova-T disconnects, but it at least solves that
the machine doesn't go down when this happens till the driver gets
fixed.
I think it would have been nice to get that patch into it

Markus

> For one of the bugs, it became obvious when someone looked at it after
> the release of 2.6.21 that between the bug report on March 31th and the
> release of 2.6.21 on April 21th, noone started debugging this bug. [3] [4]
>
> > > And look e.g. at the many (and non-trivial) changes between -rc7 and
> > > -final, resulting in more than one report from people who were running
> > > -rc7 without problems - and 2.6.21 doesn't work for them.
> >
> > I agree that's unfortunate.
> >
> > > It's not a choice between "regressions don't matter" and "no
> regressions",
> > > it's about the place in the area between these two extremes. I have my
> > > opinions on what I want to expect from a stable Linux kernel, and other
> > > people have different opinins.
> >
> > Everyone is going to disagree to some extent; and their own comfort
> > zone.  So a certain amount compromise is always going to be necessary.
> > Of course, it's up to you decide whether this has gone beyond the zone
> > where you aren't comfortable working with other people's development
> > style.
> >
> > Regards,
> >
> > 					- Ted
>
> cu
> Adrian
>
> [1] http://lkml.org/lkml/2007/4/26/2
> [2] http://lkml.org/lkml/2007/4/25/496
> [3] http://lkml.org/lkml/2007/4/26/496
> [4] and although it turned out this specific regression was already
>     fixed in 2.6.21, I hope you get my point
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
