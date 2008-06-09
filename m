Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbYFIQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbYFIQzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbYFIQzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:55:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4275 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbYFIQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:54:50 -0400
Date: Mon, 9 Jun 2008 17:54:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
Message-ID: <20080609165438.GE17278@sirena.org.uk>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange> <200806052229.37143.david-b@pacbell.net> <Pine.LNX.4.64.0806091109120.21876@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806091109120.21876@axis700.grange>
X-Cookie: The worst is enemy of the bad.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 06:23:50PM +0200, Guennadi Liakhovetski wrote:
> On Thu, 5 Jun 2008, David Brownell wrote:
> > On Monday 02 June 2008, Guennadi Liakhovetski wrote:

> > > as far as I understand, the current GPIO API only presents very basic GPIO 
> > > functionality: direction and level reading and writing. Whereas many GPIO 
> > > controllers have many further configurable parameters: pull-ups and 
> > > pull-downs, drive strength, slew rate, etc.

> > Not at all how I'd describe it.  Those omitted mechanisms are part
> > of pin configuration, in the same way as function multiplexing is.
> > (That is, assigning a given pin for use as a GPIO, vs hooking it up
> > to an I2C, MMC, SPI, LCD, I2S, or memory controller.)

> Yes, on the one hand you're right, this belongs to pin-configuration. But, 
> otoh, will anyone ever want to change these parameters on non-generic 
> pins? And should this be allowed? Whereas for GPIOs it clearly makes a 

They do get configured like that - for example, most I2S devices are
able to operate as both clock masters and clock slaves.  Often this
accomplished (at least in part) by configuring the relevant pins as
inputs or outputs.
