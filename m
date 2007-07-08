Return-Path: <linux-kernel-owner+w=401wt.eu-S1751026AbXGHEmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbXGHEmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXGHEl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:41:57 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:49294 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXGHEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p4C0V/SiYjyLh+ye37FDnBzz1l7twpFDE7rlnbYYOpkTrFQuFtt+Mg0yyuUyYAGIp5yt8GIz1O5xRAPMj4zoSq0keI+3GCgB8qOh3Z8UXOBpilXQi3Msr3evBresVdgRXddoeWm08y0nVIhAOMRa9WiMeHkSaQDCuxr3g34vfhs=
Message-ID: <9a7c669e0707072141i7d0f6f65r8cdeee908202620d@mail.gmail.com>
Date: Sun, 8 Jul 2007 00:41:55 -0400
From: "Tim Hull" <thully@umich.edu>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: PROBLEM: MacBook makes whining noise when usb-uhci active
Cc: "Gerald Britton" <gbritton@doomcom.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070708042712.GC12052@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a7c669e0707071551v2705320dn876ad208fa60a537@mail.gmail.com>
	 <Pine.LNX.4.44L0.0707072210470.10912-100000@netrider.rowland.org>
	 <20070708025457.GA2822@zante.sekrit.org>
	 <20070708042712.GC12052@khazad-dum.debian.net>
X-Google-Sender-Auth: 3e12ff395c344baf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After reading the ThinkPad wiki link, I've found that the problem has
to do with the C3 and C4 ACPI states.  I'm guessing that the 2.6.18
kernel I was using on Debian Etch just happened to not support full
power management on my MacBook - hence, the problem didn't occur.

 Sorry for all of this - I guess I'll pass this info on to Apple and
see if they may be able to fix this with a firmware update (it occurs
on OS X too).
On 7/8/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Sat, 07 Jul 2007, Gerald Britton wrote:
> > On Sat, Jul 07, 2007 at 10:17:34PM -0400, Alan Stern wrote:
> > > > [2.] Full description of the problem/report: On my MacBook (first generation
> > > > Core Duo 1.83GHz), I can hear a faint whining noise that becomes audible
> > > > when usb-uhci is loaded and remains audible except when the USB ports are in
> > > > use (i.e. the noise temporarily stops when I'm copying music to my iPod).
> > >
> > > You have a USB keyboard, right?  So the ports are always in use --
> > > unless you unplug the keyboard.
> > >
> > > > This problem occurs on both 2.6.21  and 2.6.22-rc7, but does not occur on
> > > > 2.6.18.  Unloading usb-uhci when booted in 2.6.22-rc7 makes the whining
> > > > noise stop, but the system is useless in this state for obvious reasons.
> > > > The same whine does occur in OS X that occurs in 2.6.22-rc7 (though it does
> > > > NOT occur in 2.6.18)
> > >
> > > Anyway it's clearly a hardware problem, even if it is triggered by
> > > something in software.  About all I can suggest is to surround the
> > > MacBook with something sound-absorbent.  (Not very helpful, I agree.)
> >
> > I have a similar problem with my new Thinkpad X60 Tablet.  In this case,
> > I have a high pitched whine which is only caused when USB drivers are loaded,
> > I am on battery, and there are no devices connected to USB.  I suspect
> > something involved with CONFIG_USB_SUSPEND (which is enabled) is causing this
> > whine, but I haven't dug deeper to find out a more precise cause.
> >
> > For reference, I'm running Fedora 7's 2.6.21-1.3228.fc7 x86_64.
>
> http://www.thinkwiki.org/wiki/Problem_with_high_pitch_noises  might give you
> some hints, and yes, it is a hardware design problem.
>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
>
