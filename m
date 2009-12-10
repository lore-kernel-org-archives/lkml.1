Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbZLJRlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbZLJRlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbZLJRlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:41:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49240 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760896AbZLJRla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:41:30 -0500
Date: Thu, 10 Dec 2009 17:41:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091210174127.GA22554@sirena.org.uk>
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210172458.GJ19454@elf.ucw.cz>
X-Cookie: Quack!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 06:24:58PM +0100, Pavel Machek wrote:

> > Further to this, I think it is worth doing the work to make this gpiolib
> > now. Most of the other ARM chips now support gpiolib, so it would seem a
> > bit of a step backwards to start adding new chips which don't. I think
> > that adding the gpiolib support will also cleanup the mess that is
> > register_gpio_chip, since this is all already handled by the gpiolib core.

> I tried going through drivers/gpio/gpiolib.c and it seems to be a lot
> of code -- mostly sysrq interface to userland. I'm not sure how much
> code could be shared... 

Everything in generic_gpio.c could easily be shared, which also gives
you all the standard APIs drivers and userspace expect without having to
reimplement them or ending up with slightly incompatible implementations.
