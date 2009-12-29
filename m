Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbZL2Tma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbZL2Tma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZL2Tm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:42:29 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64435 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZL2Tm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:42:28 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX197BzGGIXEDkak0Kj6fHoQ0
Date: Tue, 29 Dec 2009 11:42:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Luke-Jr <luke@dashjr.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for
 Nokia N800 and N810
Message-ID: <20091229194215.GD3512@atomide.com>
References: <200912290152.16357.luke@dashjr.org>
 <20091229192407.GA3512@atomide.com>
 <1262115349.28789.79.camel@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262115349.28789.79.camel@gandalf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <me@felipebalbi.com> [091229 11:34]:
> Hi,
> 
> On Tue, 2009-12-29 at 11:24 -0800, Tony Lindgren wrote:
> > Great. The comment from Russell earlier was that we should be now using
> > clkdev to do things like this and get rid of the _set_clock functions.
> > In musb_core.c are already using the clk directly if set_clock is NULL.
> > 
> > Can you try the patch below? If it works, just merge it into your
> > patch.
> 
> Yes, let's do like Tony suggested. I'm removing the old set_clock stuff
> completely, patches are available at my git tree, here are the links:
> 
> http://gitorious.org/usb/usb/commit/ca415cf06a4843e93041fe73f7f1867e066b48a3
> http://gitorious.org/usb/usb/commit/013f8457a1ba0dd3f36811f647b0fe904128292e
> http://gitorious.org/usb/usb/commit/e2ecae4c5b01415dbbf714c7217178c31a9a5dd1
> http://gitorious.org/usb/usb/commit/874afb373ea75ff0a3a360802a53357affa27df0
> http://gitorious.org/usb/usb/commit/6d47fc9858c17faea8a454e147839c878737a0f1
> http://gitorious.org/usb/usb/commit/62b8d94df7739cb60bae0369b8265e588f518841
> http://gitorious.org/usb/usb/commit/e06629acd44936fe87d34d188c8dfb54abd7915c
> 
> Tony, if you want I can send you a pull request will all the patches I
> have prepared on top of your tree. There's only one dependence which I
> can ship in the same pull request.

That would be great!
 
> Sames goes to Kevin regarding davinci tree. I just have to subscribe in
> order to be able to send the patches there.

FYI, I think Kevin is on vacation right now.

Regards,

Tony
