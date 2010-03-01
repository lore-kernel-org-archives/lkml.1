Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873Ab0CAKfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:35:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53802 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750764Ab0CAKfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:35:53 -0500
Date: Mon, 1 Mar 2010 10:35:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Gardner <gardner.ben@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
Message-ID: <20100301103550.GA24518@rakim.wolfsonmicro.main>
References: <cover.1267225701.git.gardner.ben@gmail.com>
 <201002270824.14889.david-b@pacbell.net>
 <A6EC110C-1712-4AC7-B828-D7BB08278996@opensource.wolfsonmicro.com>
 <201002270951.09045.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201002270951.09045.david-b@pacbell.net>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 09:51:08AM -0800, David Brownell wrote:
> On Saturday 27 February 2010, Mark Brown wrote:

> > Indeed, but some devices do implement a distinct tristate state for  
> > input mode pins (disabling interrupt generation logic and so on for  
> > example).

> That's a pretty sloppy usage of the term "tristate" ... yeah, there
> are people who take glee in abusing terminology to introduce confusion,
> and some of them write technical manuals with little regard to normal
> usage of terms (or trademarks, which do exist for "tristate").

It's a bit clearer when the pins have multiple functions of which GPIO
is only one - normally the tristate is something that applies over all
the functions of the GPIO.

> IRQ generation logic should be disabled until request_irq() code paths
> report otherwise.   And regardless, whether a GPIO triggers an IRQ has
> nothing at all to do with its "direction".

This is an internal Linux implementation issue rather than a hardware
one - that was just an example one of the things that tristating the pin
rather than just putting it into input mode does.
