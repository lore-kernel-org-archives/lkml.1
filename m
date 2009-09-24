Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZIXSVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZIXSVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZIXSVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:21:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:12017 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZIXSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:21:48 -0400
Subject: Re: [PATCH] regulator: add driver for MAX8660/8661
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090924180727.GA6408@pengutronix.de>
References: <1253798645-9493-1-git-send-email-w.sang@pengutronix.de>
	 <20090924173904.GA9082@sirena.org.uk>
	 <20090924180727.GA6408@pengutronix.de>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 19:21:46 +0100
Message-Id: <1253816506.11624.889.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 20:07 +0200, Wolfram Sang wrote:
> > > +	if (MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP > max_uV)
> > > +		return -EINVAL;
> > 
> > Not important but using list_voltage() here would be a little nicer.
> 
> Well, uhm, yeah :)
> 
> > > +static struct regulator_ops max8660_dcdc_ops = {
> > > +	.is_enabled = max8660_dcdc_is_enabled,
> > > +	.list_voltage = max8660_dcdc_list,
> > > +	.set_voltage = max8660_dcdc_set,
> > > +	.get_voltage = max8660_dcdc_get,
> > > +	/* no set_mode() & friends: forced PWM does not save any power */
> > 
> > Forced PWM is normally a power loss - the benefit it gives is the
> > ability to respond to sudden spikes in load without voltage droops.  The
> > power benefit from not having it enabled is usually only apparent at
> > lower loads.
> 
> Understood. Well, as this chip automatically switches PWM on/off depending on
> the load (formula is in the datasheet), it seems to me that the forced-PWM mode
> is mainly used for systems which prefer low-noise on the signal. So, the above
> comment could just be dropped. Liam, could you do this, or shall I resend?

Would be easier for me if you could resend. Mark and I are at LPC today
so not really in a position to code (or even answers mails quickly).

Thanks

Liam

