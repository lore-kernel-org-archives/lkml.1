Return-Path: <linux-kernel-owner+w=401wt.eu-S973035AbXHMR6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973035AbXHMR6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938680AbXHMRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:45:56 -0400
Received: from foo.birdnet.se ([213.88.146.6]:52940 "EHLO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032259AbXHMRpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:45:49 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 13:45:49 EDT
Message-ID: <20070813173906.14407.qmail@cdy.org>
Date: Mon, 13 Aug 2007 19:39:06 +0200
From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Samuel Ortiz <samuel@sortiz.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Linus Walleij \(LD/EAB\)" <linus.walleij@ericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Mail-Followup-To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	Samuel Ortiz <samuel@sortiz.org>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	"Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706300545.43181.bjorn.helgaas@hp.com> <200708112239.37475.arvidjaar@mail.ru> <200708131009.46641.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708131009.46641.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 10:09:46AM -0600, Bjorn Helgaas wrote:
> > [ 2207.986873] smsc_ircc_present: can't get sir_base of 0x2e8
> 
> As of 2.6.23-rc2, we should have:
>   - probes for 8250 legacy devices (as in 2.6.21 and previous)
>   - smsc PNP probes turned off by default (2.6.21 and previous had
>     no PNP probes for smsc at all)
>   - some complicated PNP quirks for SMCf010 devices
> 
> In other words, I think we're basically back where we started.  The
> 8250 driver should find a ttyS3 device at 0x2e8, and it should
> claim those ports, which will prevent smsc from claiming them.

I use 8250.nr_uarts=1 appended to my kernel parameters on my laptop.
Perfectly reliable workaround, but if it is possible to detect, then
all the better!


//Peter
