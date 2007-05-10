Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbXEJVbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbXEJVbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbXEJVbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:31:42 -0400
Received: from www.osadl.org ([213.239.205.134]:54134 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755635AbXEJVbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:31:42 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: David Brownell <david-b@pacbell.net>
Subject: Re: drivers/mtd/devices/at91_dataflash26.c
Date: Thu, 10 May 2007 23:31:11 +0200
User-Agent: KMail/1.9.5
Cc: dwmw2@infradead.org, Andrew Victor <andrew@sanpeople.com>,
       tglx@linutronix.de, Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704271812.26392.david-b@pacbell.net> <200704271908.17403.david-b@pacbell.net> <200705101307.19794.david-b@pacbell.net>
In-Reply-To: <200705101307.19794.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705102331.12366.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 10 Mai 2007 22:07 schrieb David Brownell:
> On Friday 27 April 2007, David Brownell wrote:
> > On Friday 27 April 2007, Hans-Jürgen Koch wrote:
> > 
> > > > 	 the m25p80 driver
> > > > was pretty close to working with those Atmel devices too ...
> > > > most of the commands are identical.
> > > 
> > > Thanks for that hint, I'll have a look at the data sheet.
> 
> Any progress on that?  I looked again, and yes most commands
> are identical.
> 
>  - That driver relies on an AT91-only SPI stack that's not
>    going upstream, instead of drivers/spi/atmel_spi.c;
> 
>  - Driver can't even be selected on kernel.org kernel (!!);
> 
>  - The m25p80 driver will need at most minor tweaks to
>    handle those AT26 (and AT25) series chips;
> 
> So 340ea370c2ce89d1c15fbf785460f2f74314ce58 should be reverted.
> 
> - Dave
>

Dave,
sorry for not responding earlier, I was busy with lots of other 
stuff. At the moment, I'm working on this again. I had a bit
of trouble getting a recent kernel working on my test system,
but that seems to be OK now.

You'll hear from me soon.

Thanks,
Hans

