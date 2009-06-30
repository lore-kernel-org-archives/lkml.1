Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZF3TQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZF3TQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZF3TPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:15:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42936 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754729AbZF3TPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:15:46 -0400
Date: Tue, 30 Jun 2009 20:15:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
 and use it for olpc driver
Message-ID: <20090630191547.GA24002@rakim.wolfsonmicro.main>
References: <20090630021730.44f86185@mycelium.queued.net>
 <20090630113135.GD13961@sirena.org.uk>
 <20090630110430.6c7c5cdf@mycelium.queued.net>
 <20090630153719.GA13300@oksana.dev.rtsoft.ru>
 <20090630155713.GG13961@sirena.org.uk>
 <20090630190239.GA21667@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630190239.GA21667@oksana.dev.rtsoft.ru>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 11:02:39PM +0400, Anton Vorontsov wrote:
> On Tue, Jun 30, 2009 at 04:57:14PM +0100, Mark Brown wrote:

> > I strongly suspect you will find that the "slow" mode there is actually
> > a trickle charge.  It's a lot more practical to trickle charge in mobile
> > phone sized systems since the batteries are so much smaller than laptop
> > batteries. 

...

>  For a Li-ion battery, the precharge current is typically 0.1C
>  (C = charge rate = the charge current which will fully charge the
>  battery in one hour)."

Yup, that sounds like a trickle charge all right.

> There is also precharge-wait and fastcharge-wait modes, FWIW.
> But we don't expose this information to the userspace.

Those *probably* boil down to one of the other states - without looking
at the datasheet they sound like waiting for the conditions required to
do one of the other charges to be satisfied.

> Probably not, Fast/Slow/Trickle are quite vague terms anyway.
> I'd prefer if we could measure this in some real units, but alas...

Fast and trickle charge are fairly well understood terms, I think.  For
specific numbers you'd need to look at the particular batteries
involved, unfortunately, but they do tend to be fairly obvious when
looking at a particular charger and/or battery.
