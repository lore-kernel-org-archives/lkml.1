Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZGWI5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZGWI5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZGWI5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:57:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33308 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751881AbZGWI5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:57:40 -0400
Date: Thu, 23 Jul 2009 09:57:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [RFC] [PATCH 3/3] ASoC: add support for Amstrad
 E3 (Delta) machine
Message-ID: <20090723085738.GC5744@rakim.wolfsonmicro.main>
References: <200907220523.01107.jkrzyszt@tis.icnet.pl>
 <4A6727D8.5080808@tis.icnet.pl>
 <20090722150709.GB4987@rakim.wolfsonmicro.main>
 <200907222118.06396.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907222118.06396.jkrzyszt@tis.icnet.pl>
X-Cookie: <wiggy> bwah, vodka in my mouse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:18:05PM +0200, Janusz Krzysztofik wrote:

> After all, I am not sure what your preferences finally are. If you still think 
> that exporting gpio based jack state from ASoC framework over gpiolib sysfs 
> doesn't hurt and can be usefull, I'll remove the code from my driver and 
> provide a patch against sound/soc/soc-jack.c. But if you would rather prefere 
> exposing jack state in a more general, not gpio limited way instead, or 
> depend on input layer provided EVIOCGSW ioctl, as Dmitry suggested 
> (unfortunatelly, unlike generic ldattach, there is no utility ready for 
> use!), I'd rather keep this gpio_export() in my driver, let's say for 
> diagnostic purposes, at least until that different option is ready for use in 
> a convenient way.

Jack state is already exposed via the input layer by the ALSA jack core.
Reporting of GPIO state via gpio_export() would be additional to that
and would be purely for debug purposes, it would not be recommended for
use by userspace applications.
