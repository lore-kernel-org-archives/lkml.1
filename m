Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468Ab0AHI2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0AHI2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086Ab0AHI2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:28:32 -0500
Received: from trinity.fluff.org ([89.16.178.74]:48224 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0AHI2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:28:31 -0500
Date: Fri, 8 Jan 2010 08:28:26 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-samsung-soc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpiolib: add gpio_lookup_chip() to get chip
	information for gpio
Message-ID: <20100108082826.GC1224@trinity.fluff.org>
References: <1262932348-2888-1-git-send-email-ben-linux@fluff.org> <1262932348-2888-2-git-send-email-ben-linux@fluff.org> <f17812d71001072330t7a9f7607v8b55b2fc346745e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d71001072330t7a9f7607v8b55b2fc346745e5@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 03:30:36PM +0800, Eric Miao wrote:
> On Fri, Jan 8, 2010 at 2:32 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> > Add a call to get the 'struct gpio_chip' pointer for a given gpio, so
> > that core implementations which want to use gpiolib gpio numbering for
> > things like mux configuration can get back to the gpio_chip that they
> > registered without having to have their own list of gpio.
> >
> > This is especially useful for the Samsung S3C64XX series where the GPIO
> > bank sizes can vary from 32 down to 3, making it difficult to store an
> > array to convert a number to chip.
> >
> 
> I think this is generally a good idea. Will most likely be useful to
> pxa platforms as well. Not sure though if you want to export this
> symbol as well since we do allow gpio chip drivers to be modules.

Probably not, since all the gpio call methods pass gpio_chip as their
first parameter. This is only in the case we want to use gpios for
something other than in/out/irq.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

