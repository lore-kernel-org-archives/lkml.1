Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYD2X3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYD2X3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYD2X33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:29:29 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:31666
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbYD2X32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:29:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AngBAN5LF0h8qMj2/2dsb2JhbAAIrHk
X-IronPort-AV: E=Sophos;i="4.25,725,1199631600"; 
   d="scan'208";a="256124500"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: Trent Piepho <tpiepho@freescale.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <200804291455.39674.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	 <Pine.LNX.4.64.0804282202340.8286@t2.domain.actdsltmp>
	 <1209472526.311.50.camel@moss.renham>
	 <200804291455.39674.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 30 Apr 2008 09:29:32 +1000
Message-Id: <1209511772.311.55.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-29 at 14:55 -0700, David Brownell wrote:
> On Tuesday 29 April 2008, Ben Nizette wrote:
> > 4) Status quo.  Easy, efficient, potentially hard to discover which gpio
> > you actually want.
> > 
> > My vote's for 1 or 4.  The first one is heavier but easier.  The last
> > one will need something like the discussed file mapping ranges to gpios.
> 
> My vote is for #4 with a chip listing file.
> 
> I don't like the hacked names ... none of the other /sys/class/*/name
> files on any of my systems use hacked names.  The entire motivation for
> name hacking seems wrong to me, and by observation it's been rejected
> for all other class names.

Right, agreed.

I guess one last option (which is made hard by chip label non-uniqueness
but I'll throw out anyway) would be

/sys/class/gpio
	/chipa
		/gpio-n
			/value
			/direction
		/control
	/chipb
		:
		:

I guess this doesn't gain much over labelling files chipname:N (and has
the same pitfalls) but does at least seem less hackish.


	--Ben.
> 
> - Dave
> 
