Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXAZRur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXAZRur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161099AbXAZRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:50:47 -0500
Received: from lucidpixels.com ([75.144.35.66]:52310 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbXAZRuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:50:46 -0500
Date: Fri, 26 Jan 2007 12:50:45 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Adrian Bunk <bunk@stusta.de>
cc: thunder7@xs4all.nl, Avuton Olrich <avuton@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.19.2, cp 18gb_file 18gb_file.2 = OOM killer, 100% reproducible
In-Reply-To: <20070126174928.GL17836@stusta.de>
Message-ID: <Pine.LNX.4.64.0701261250240.12467@p34.internal.lan>
References: <Pine.LNX.4.64.0701201516450.3684@p34.internal.lan>
 <3aa654a40701201245s72b2f76hc70ddd94b70ba99c@mail.gmail.com>
 <Pine.LNX.4.64.0701201602570.4910@p34.internal.lan> <20070121155219.GA7413@amd64.of.nowhere>
 <Pine.LNX.4.64.0701211053370.15334@p34.internal.lan> <20070126174928.GL17836@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Jan 2007, Adrian Bunk wrote:

> On Sun, Jan 21, 2007 at 10:54:09AM -0500, Justin Piszcz wrote:
> > On Sun, 21 Jan 2007, thunder7@xs4all.nl wrote:
> > 
> > > From: Justin Piszcz <jpiszcz@lucidpixels.com>
> > > Date: Sat, Jan 20, 2007 at 04:03:42PM -0500
> > > > 
> > > > 
> > > > My swap is on, 2GB ram and 2GB of swap on this machine.  I can't go back 
> > > > to 2.6.17.13 as it does not recognize the NICs in my machine correctly and 
> > > > the Alsa Intel HD Audio driver has bugs etc, I guess I am stuck with 
> > > > 2.6.19.2 :(
> > > > 
> > > Well, if you can't go back, you could always test 2.6.20-rc5. That's why
> > > it's out there :-) It can't be any worse!
> > > 
> > > Good luck,
> > > Jurriaan
> > > -- 
> > > It might look like I'm doing nothing, but at the cellular level I'm really
> > > quite busy.
> > > 	Hans Haas
> > > Debian (Unstable) GNU/Linux 2.6.20-rc5 2x2011 bogomips load 1.97
> > > the Jack Vance Integral Edition: http://www.integralarchive.org
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > It is worse-- NAT doesn't work and HDDTEMP doesn't work anymore either.
> 
> 
> Do I understand it correctly from the further emails in this thread that 
> the NAT problem was the known netfilter options mess when upgrading from 
> 2.6.19 to 2.6.20, and enabling some more netfilter options fixed it?
> 
> 
> hddtemp has a known bug:
> 
> Subject    : `hddtemp' no longer works
> References : http://lkml.org/lkml/2006/12/14/272
>              http://bugzilla.kernel.org/show_bug.cgi?id=7581
> Submitter  : Alistair John Strachan <s0348365@sms.ed.ac.uk>
>              Nicolas Mailhot <Nicolas.Mailhot@LaPoste.net>
> Handled-By : Jens Axboe <jens.axboe@oracle.com>
> Status     : bug in hddtemp: http://bugzilla.kernel.org/show_bug.cgi?id=7581
> 
> 
> > Justin.
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

Yes, it was because the options changed positions/places, it is working 
now.

Justin.
