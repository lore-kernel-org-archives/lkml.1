Return-Path: <linux-kernel-owner+w=401wt.eu-S1422947AbXDXR4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422947AbXDXR4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422948AbXDXR4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:56:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:4600 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422931AbXDXR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UMunRyC/XzORb6+LUk46qkB9UsFPZOyWaBZyoRzwll6jti3UH+4VItRj7rKtzicowa5aTtS2yGbeeN2ZeAnSw7ecuuzzVKcWFPpWLCcQA2leEAZcSax+ICplnbZjcxpHfP8+nBh1lDEhOmy84azEUNSw6F5AfGddggifvdtp0a4=
Message-ID: <2a6e8c0d0704241056k4c7ad14dq9b638df610f4c7d1@mail.gmail.com>
Date: Tue, 24 Apr 2007 13:56:15 -0400
From: "Ian E. Morgan" <penguin.wrangler@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: cpufreq default governor
Cc: "William Heimbigner" <icxcnika@mar.tar.cc>
In-Reply-To: <Pine.LNX.4.64.0704241320080.25153@server.thyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704240755230.25153@server.thyself>
	 <6bffcb0e0704240134w45007473p5694718a0aae08fc@mail.gmail.com>
	 <Pine.LNX.4.64.0704241235560.25153@server.thyself>
	 <6bffcb0e0704240550x2c47cd1ap8101a9b0db5c6c7d@mail.gmail.com>
	 <Pine.LNX.4.64.0704241252410.25153@server.thyself>
	 <6bffcb0e0704240607s2e9b308dx448b5f477b8325e@mail.gmail.com>
	 <Pine.LNX.4.64.0704241320080.25153@server.thyself>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> On Tue, 24 Apr 2007, Michal Piotrowski wrote:
> > On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> >>  On Tue, 24 Apr 2007, Michal Piotrowski wrote:
> >>
> >> >  On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> >> > >   On Tue, 24 Apr 2007, Michal Piotrowski wrote:
> >> > >
> >> > > >   Hi William,
> >> > > >
> >> > > >   On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> >> > > > >    Question: is there some reason that kconfig does not allow for
> >> > > > >    default
> >> > > > >    governors of conservative/ondemand/powersave?
> >> > > >
> >> > > >   Performance?
> >> > > >
> >> > > > >    I'm not aware of any reason why one of those governors could not
> >> > > > >    be
> >> > > > >    used
> >> > > > >    as default.
> >> > > >
> >> > > >   My hardware doesn't work properly with ondemand governor. I hear
> >> > > >   strange noises when frequency is changed.
> >> > > >
> >> > >
> >> > >   That doesn't mean it isn't working, though.
> >> >
> >> >  I didn't say that cpufreq ondemand is broken. It's a hardware problem.
> >> >
> >> > >   I here weird noises if the cpu
> >> > >   is clocked anywhere from 333MHz to 1GHz (sounds like an RD-D2 beeping
> >> > >   noises in ultra high pitch?)
> >> >
> >> >  Yes, something like that.
> >>
> >>  Is it actually "not working" though, even at the hardware level?
> >
> > It works, but for me this sounds are very weird ;)
> >
> >>  To my
> >>  knowledge those noises are normal, and aren't even signs of a harware
> >>  problem. I believe it is the natural result of changing frequencies at any
> >>  time. If you change frequencies, especially in the low end of available
> >>  frequencies, you should hear a very brief noise. A governor such as
> >>  ondemand, which is rapidly switching the frequency from say, 333 MHz to
> >>  2.66 GHz, is likely to make this much more noticable.
> >
> > Ok, it might be normal behavior. I might be wrong, but IMO users
> > prefer speed and no strange sounds as default setting.
>
> I agree! My suggestion, however, is that if they do want a different
> scheduler as the default, they can choose one.
>
> There are some cases in which this could be very useful. A couple examples
> would be the processor with poor cooling that overheats easily, or a
> laptop with a poor battery.
>
> However, on second thought with regards to Kconfig, would it be feasible
> to have performance always be the default, unless a
> "cpufreqgov=conservative" arguement was specified on the command line?
>
> This would be less susceptible to users complaining that their cpu is
> chirping all of a sudden.

I'm all for the ability to set the default to whatever governor the
user wants. I _always_ run my laptops with the ondemand governor, my
Pentium M-based PVR runs with ondemand too, and only my old P4 box
doesn't because it's pointless. If you're running servers that
_aren't_ going to be idle most of the time, then by all means set your
default to performance, or just don't enable cpufreq at all, but give
the rest of us the option.

Particularily with laptops, I've always wanted the kernel to boot and
immediately slow the CPU down, even if all I do is boot into single
user mode, or even bypass init altogether. This will give best battery
life and coolest operation out of the box without having to rely on
userland whatsoever.

I had an old laptop a while back that _would_ overheat and shutdown
within a couple of minutes, even though idle, if booted to single user
mode because the cpu freq wasn't slowed down.

-- 
Ian Morgan
