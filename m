Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZK2Euq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZK2Euq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 23:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZK2Eup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 23:50:45 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:55141 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbZK2Euo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 23:50:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oZvk+ACfLW1uCb7tUBbhZ57GxYiVA4KBDrBmg7fh+9Hf2Bdzcv5/rBj+3VJdP0rc8O
         Yzq5qXUwbcTyI5MhmZOd90DUH8Ct2wkl7AjHFe2y0w5GbjLkOp/YGlQ8XoUiq3AC99BX
         /fmWtgxt2SyYaQ/PCnqH4ZtaXiaS7a+Y9UQ9E=
Date: Sat, 28 Nov 2009 20:50:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Jon Smirl <jonsmirl@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       maximlevitsky@gmail.com, mchehab@redhat.com, stefanr@s5r6.in-berlin.de,
       superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091129045045.GP6936@core.coreip.homeip.net>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> <1259469121.3125.28.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259469121.3125.28.camel@palomino.walls.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 11:32:01PM -0500, Andy Walls wrote:
> On Sat, 2009-11-28 at 12:37 -0500, Jon Smirl wrote:
> > On Sat, Nov 28, 2009 at 12:35 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > > Jon Smirl <jonsmirl@gmail.com> writes:
> > >
> > >> There are two very basic things that we need to reach consensus on first.
> > >>
> > >> 1) Unification with mouse/keyboard in evdev - put IR on equal footing.
> 
> BTW, circa 1995 my serial mouse "Just Worked" in Linux.  Sometime around
> the release of Fedora Core 3 or 4, serial mice stopped being well
> supported as input devices AFAICT.  (I still have a dual boot
> Windows95/Linux machine with a serial mouse because it has ISA slots.)
>

serport + sermouse combo should work well. At least I don't get any bug
reports ;P

 
> Are serial port connected IR devices going to see the same fate in this
> model?
> 
> 
> Why not consider IR devices as bi-directional communications devices vs.
> input devices like mice or keyboards?  Theoretically the TTY layer with
> line discipline modules for underlying IR hardware could also interface
> IR devices to user space.
> 
> Sorry, the input subsystem cannot meet all the end user IR requirements.

Again, what end users are you taling about here? An application that
wants to prcess key (or button) presses? Or something entirely
different, lice lirc itself?

> I doubt it could easily support all the current user space only IR
> drivers moving into the kernel.  I suspect the serial port connected IR
> devices will be deemed "too hard" and IR Tx as "not input" and dropped
> on the floor.
> 
> 
> The more I think about IR integration with input, the more I think any
> effort beyond the plug-and-plug for default configurations is a waste of
> time and effort.  Something more is needed to handle the transmitters
> and serial connected IRs.  It's also too convenient to access USB IR
> hardware from existing userspace drivers to bother porting into the
> kernel.

Having support 2 different interfaces for regular applications is also a
waste of time and effort. The applications who don;t care about IRC
protocol decoding should be able to just work with standard input
interface.

-- 
Dmitry
