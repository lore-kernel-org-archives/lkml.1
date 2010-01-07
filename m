Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460Ab0AGRZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0AGRZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196Ab0AGRZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:25:20 -0500
Received: from dan.rpsys.net ([93.97.175.187]:61829 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab0AGRZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:25:19 -0500
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
From: Richard Purdie <rpurdie@rpsys.net>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Daniel Mack <daniel@caiaq.de>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-geode@lists.infradead.org" <linux-geode@lists.infradead.org>
In-Reply-To: <4B45E905.7040401@nets.rwth-aachen.de>
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
	 <1262861484.8493.14.camel@dax.rpnet.com>
	 <4B45CC4C.4030603@nets.rwth-aachen.de>
	 <4B45CF73.9090304@nets.rwth-aachen.de>
	 <20100107124630.GU28375@buzzloop.caiaq.de>
	 <4B45E905.7040401@nets.rwth-aachen.de>
Content-Type: text/plain
Date: Thu, 07 Jan 2010 17:27:21 +0000
Message-Id: <1262885241.27762.1.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 15:00 +0100, Arnd Hannemann wrote:
> Daniel Mack schrieb:
> > On Thu, Jan 07, 2010 at 01:11:31PM +0100, Arnd Hannemann wrote:
> >> Arnd Hannemann schrieb:
> >> Oh, maybe using cs5535_gpio AND leds_alix2 together was never supposed to work?
> > 
> > That is the problem indeed. The problem is that three of these GPIOs are
> > connected to LEDs, so if both drivers are enabled, they will both alter
> > the same GPIOs. Hmm, don't know how to handle this. Maybe the LED driver
> > should use the GPIO interface and that's it?
> 
> I'm not sure that this configuration needs to be supported at all,
> so disallowing that both drivers are configured via Kconfig could be a simple solution.

Agreed, Kconfig dependencies for this until the code is improved look
like the best option. Does someone want to send me a patch?

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

