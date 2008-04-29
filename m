Return-Path: <linux-kernel-owner+w=401wt.eu-S934620AbYD2AsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620AbYD2AsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYD2Ar5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:47:57 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:7080
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbYD2Ar4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:47:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsBAB4NFkh8qMj2/2dsb2JhbAAIrAI
X-IronPort-AV: E=Sophos;i="4.25,719,1199631600"; 
   d="scan'208";a="307916481"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net>
	 <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 29 Apr 2008 10:47:47 +1000
Message-Id: <1209430067.14631.36.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 16:09 -0700, Trent Piepho wrote:
> On Mon, 28 Apr 2008, David Brownell wrote:
> > Simple sysfs interface for GPIOs.
> >
> >    /sys/class/gpio
> >        /gpio-N ... for each exported GPIO #N
> 
> I liked it better they way I had it, "label:N".
> 
> When you have multiple GPIO sources, it's a lot easier to see where they are
> comming from if they use the chip label.  Especially if support for dynamic
> allocation of gpio numbers is written.
> 
> 
> > 	    /value ... always readable, writes fail except for output GPIOs
> > 	    /direction ... writable as: in, out (default low), high, low
> 
> You took away the code for the label field?  That was one of the features of
> my code that Ben Nizette mentioned as an advantage over a char-device
> interface.

If all gpios are exported read only by default then keeping the label
either in the folder naming or as a file is certainly useful to identify
what you actually want to talk to.  If you're debugging a driver or
you've already manually exported a gpio then I'd assume you already know
pretty much all you need to know about that pin.

	--Ben.

