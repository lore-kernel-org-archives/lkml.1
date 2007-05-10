Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXEJVQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXEJVQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758381AbXEJVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:16:37 -0400
Received: from www.osadl.org ([213.239.205.134]:57455 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757937AbXEJVQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:16:36 -0400
Subject: Re: drivers/mtd/devices/at91_dataflash26.c
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: David Brownell <david-b@pacbell.net>
Cc: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       dwmw2@infradead.org, Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <200705101307.19794.david-b@pacbell.net>
References: <200704271812.26392.david-b@pacbell.net>
	 <200704280336.44913.hjk@linutronix.de>
	 <200704271908.17403.david-b@pacbell.net>
	 <200705101307.19794.david-b@pacbell.net>
Content-Type: text/plain; charset=utf-8
Date: Thu, 10 May 2007 23:19:33 +0200
Message-Id: <1178831974.22481.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Thu, 2007-05-10 at 13:07 -0700, David Brownell wrote:
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

We look into this and fix the problem. There is no need to revert it
right now. It does no harm and we remove it with the merge into the
m25p80 driver, ok ?

	tglx


