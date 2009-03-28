Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZC1Gca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZC1Gca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 02:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZC1GcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 02:32:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47094 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZC1GcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 02:32:19 -0400
Date: Sat, 28 Mar 2009 07:32:11 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@redhat.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH 04/58] move at91_ether's probe function to .devinit.text
Message-ID: <20090328063211.GA1041@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-4-git-send-email-u.kleine-koenig@pengutronix.de> <200903271709.38383.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903271709.38383.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, Mar 27, 2009 at 05:09:37PM -0700, David Brownell wrote:
> On Friday 27 March 2009, Uwe Kleine-König wrote:
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> IMO that's preferable for this driver.  There's no
> point in doing anything other than discarding the
> probe() method after the driver has been set up;
> it'd be doing nothing except wasting memory.
> 
> Same thing for ... pretty much all other drivers
> for SoC platform devices.
> 
> In this series, you cc'd me on four OMAP drivers
> (mmci-omap, mmci-omap-hs, omap-rng, omap_udc) which
> I *know* that's a completely workable -- and far
> preferable -- solution.  There might be others.
So if I convert them to the alternative fix, you volunteer to test these
patches?  (Or at least provide your Tested-and-Acked-by:?)

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
