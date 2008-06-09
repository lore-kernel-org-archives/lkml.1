Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYFIRIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYFIRIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYFIRIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:08:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:38943 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751522AbYFIRIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:08:40 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+dLo94OPydui1UBb2N9cGGR3MLsfK6SqhN6MyEud
	0Gra2m+joEYMVg
Date: Mon, 9 Jun 2008 19:09:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
In-Reply-To: <20080609165438.GE17278@sirena.org.uk>
Message-ID: <Pine.LNX.4.64.0806091906420.25460@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
 <200806052229.37143.david-b@pacbell.net> <Pine.LNX.4.64.0806091109120.21876@axis700.grange>
 <20080609165438.GE17278@sirena.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Mark Brown wrote:

> On Mon, Jun 09, 2008 at 06:23:50PM +0200, Guennadi Liakhovetski wrote:
> > On Thu, 5 Jun 2008, David Brownell wrote:
> > > On Monday 02 June 2008, Guennadi Liakhovetski wrote:
> 
> > > > as far as I understand, the current GPIO API only presents very basic GPIO 
> > > > functionality: direction and level reading and writing. Whereas many GPIO 
> > > > controllers have many further configurable parameters: pull-ups and 
> > > > pull-downs, drive strength, slew rate, etc.
> 
> > > Not at all how I'd describe it.  Those omitted mechanisms are part
> > > of pin configuration, in the same way as function multiplexing is.
> > > (That is, assigning a given pin for use as a GPIO, vs hooking it up
> > > to an I2C, MMC, SPI, LCD, I2S, or memory controller.)
> 
> > Yes, on the one hand you're right, this belongs to pin-configuration. But, 
> > otoh, will anyone ever want to change these parameters on non-generic 
> > pins? And should this be allowed? Whereas for GPIOs it clearly makes a 
> 
> They do get configured like that - for example, most I2S devices are
> able to operate as both clock masters and clock slaves.  Often this
> accomplished (at least in part) by configuring the relevant pins as
> inputs or outputs.

The primary purpose of the GPIO-parameter proposal was to allow to 
configure these parameters from the user-space over sysfs by extending the 
gpio-sysfs patch. And I2S master / slave operation should not be 
switchable over sysfs, should it?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
