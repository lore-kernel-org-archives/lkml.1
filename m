Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYGRFJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYGRFJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYGRFJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:09:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:27848 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYGRFJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:09:34 -0400
Date: Thu, 17 Jul 2008 23:09:30 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Trent Piepho <tpiepho@freescale.com>, Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080718050930.GD9795@secretlab.ca>
References: <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp> <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru> <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca> <20080717152006.GA26120@polina.dev.rtsoft.ru> <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com> <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp> <20080717234201.GA15745@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717234201.GA15745@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 03:42:01AM +0400, Anton Vorontsov wrote:
>
<lots of legitimate frustration snipped>
> So..
> 
> Trent, I encourage you to collect your patch snippets into complete patch,
> and post it so it could slip into 2.6.27 (the bad thing is that your
> approach involves changes to the existing drivers, not just adding new
> driver that could slip even into -rc9).
> 
> That is, I have a bunch of patches in my stg queue on which I can work
> with more fun, so I'm somewhat glad that somebody will take care of the
> notorious OF GPIO LEDs. ;-)

Okay.  Thank you for all your work; it is *much* appreciated.  I'm sorry
that these things didn't come up earlier and I feel your pain.  :-)

Trent, I'd be happy to help and do what I can to expedite getting of
gpio-leds support merged in the .27 window.

> > I like the first better.  It follows the example from the docs about how
> > devices with multiple gpios should work too.
> 
> IMO, each LED is a device. So, I would rather define compatible = <> for
> each led.

If we choose that all gpio-leds will have a common parent, then I'd
still argue for the compatible property to be on the parent node because
all the children are homogeneous.

g.
