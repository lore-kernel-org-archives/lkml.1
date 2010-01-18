Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090Ab0ARN7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0ARN7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184Ab0ARN7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:59:41 -0500
Received: from dan.rpsys.net ([93.97.175.187]:59660 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab0ARN7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:59:41 -0500
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
From: Richard Purdie <rpurdie@rpsys.net>
To: Daniel Mack <daniel@caiaq.de>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-geode@lists.infradead.org" <linux-geode@lists.infradead.org>
In-Reply-To: <20100110122754.GC8970@buzzloop.caiaq.de>
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
	 <1262861484.8493.14.camel@dax.rpnet.com>
	 <4B45CC4C.4030603@nets.rwth-aachen.de>
	 <4B45CF73.9090304@nets.rwth-aachen.de>
	 <20100107124630.GU28375@buzzloop.caiaq.de>
	 <4B45E905.7040401@nets.rwth-aachen.de>
	 <1262885241.27762.1.camel@dax.rpnet.com>
	 <20100108030837.GY28375@buzzloop.caiaq.de>
	 <4B46EDA1.4030902@nets.rwth-aachen.de>
	 <20100110122754.GC8970@buzzloop.caiaq.de>
Content-Type: text/plain
Date: Mon, 18 Jan 2010 13:59:35 +0000
Message-Id: <1263823175.26227.102.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 13:27 +0100, Daniel Mack wrote:
> Subject: [PATCH] LEDS: ALIX2: Add dependency to !GPIO_CS5335
> 
> The ALIX2 LED driver and the CS5535 GPIO drivers share the same I/O
> range which causes a conflict if they're both enabled. Fix this for now
> by adding Kconfig dependencies. While at it, also drop the EXPERIMENTAL
> flag, as the code has been around for awhile already.
> 
> Note that this is a hack. At some point, a real platform support for
> this board should be added which handles the LEDs via the leds-gpio
> driver.

Queued in the LED tree, thanks. I'll push this one to Linus shortly for
2.6.33.

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

