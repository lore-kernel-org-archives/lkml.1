Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXFYGfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXFYGfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXFYGfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:35:44 -0400
Received: from www.osadl.org ([213.239.205.134]:47139 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380AbXFYGfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:35:43 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: David Brownell <david-b@pacbell.net>
Subject: Re: drivers/mtd/devices/at91_dataflash26.c
Date: Mon, 25 Jun 2007 08:35:04 +0200
User-Agent: KMail/1.9.5
Cc: dwmw2@infradead.org, Andrew Victor <andrew@sanpeople.com>,
       tglx@linutronix.de, Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704271812.26392.david-b@pacbell.net> <200705102331.12366.hjk@linutronix.de> <200706241951.37589.david-b@pacbell.net>
In-Reply-To: <200706241951.37589.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706250835.04848.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 25 Juni 2007 04:51 schrieb David Brownell:
> On Thursday 10 May 2007, Hans-Jürgen Koch wrote:
> > Am Donnerstag 10 Mai 2007 22:07 schrieb David Brownell:
> > > On Friday 27 April 2007, David Brownell wrote:
> > > > On Friday 27 April 2007, Hans-Jürgen Koch wrote:
> > > > 
> > > > > > 	 the m25p80 driver
> > > > > > was pretty close to working with those Atmel devices too ...
> > > > > > most of the commands are identical.
> > > > > 
> > > > > Thanks for that hint, I'll have a look at the data sheet.
> > > 
> > > Any progress on that?  I looked again, and yes most commands
> > > are identical.
> 
> Still true.  :)

I came to the same conclusion.

> 
> For that and a boatload of other SPI flash chips.  I'm
> wondering just what that JEDEC standard covers; either
> it's got useful command coverage, or vendors of SPI flash
> noticed that converging command sets is a Good Thing.
> 
> 
> > >  - That driver relies on an AT91-only SPI stack that's not
> > >    going upstream, instead of drivers/spi/atmel_spi.c;
> > > 
> > >  - Driver can't even be selected on kernel.org kernel (!!);
> > > 
> > >  - The m25p80 driver will need at most minor tweaks to
> > >    handle those AT26 (and AT25) series chips;
> > > 
> > > So 340ea370c2ce89d1c15fbf785460f2f74314ce58 should be reverted.
> 
> Also still true...

I agree.

> 
> 
> > > 
> > > - Dave
> > >
> > 
> > Dave,
> > sorry for not responding earlier, I was busy with lots of other 
> > stuff. At the moment, I'm working on this again. I had a bit
> > of trouble getting a recent kernel working on my test system,
> > but that seems to be OK now.
> > 
> > You'll hear from me soon.
> 
> Ping?  Have a look at
> 
>     http://lists.infradead.org/pipermail/linux-mtd/2007-June/018706.html

Great! Didn't notice that one.

> 
> which depends on the resent mutex conversion patch in the
> "previous message" link of that patch.
> 
> That should highlight more reasons why at91_dataflash should
> be reverted ASAP.  I'd expect you would be able to just drop
> that in and have it work ... 

Looks like that.

> unless you're seeing that nCS0 
> issue built out of at91rm9200 errata, in which case there's
> an experiment I can forward to you.  :)

I'll look at that ASAP. I had tons of other work on my desk and last time
I tried, SPI was broken on my device. It would be OK for me if you threw out
that at91_dataflash/at91_dataflash26 stuff now.

Thanks,
Hans

