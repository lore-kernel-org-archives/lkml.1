Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZE2JEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZE2JEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZE2JEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:04:16 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:40095 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156AbZE2JEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:04:15 -0400
Subject: Re: [PATCH] regulator/max1586: fix V3 gain calculation integer
 overflow
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87ljoh2ceg.fsf@free.fr>
References: <20090528085920.GA4624@rakim.wolfsonmicro.main>
	 <1243537203-4663-1-git-send-email-philipp.zabel@gmail.com>
	 <87ljoh2ceg.fsf@free.fr>
Content-Type: text/plain
Date: Fri, 29 May 2009 10:04:13 +0100
Message-Id: <1243587853.23130.2359.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 22:36 +0200, Robert Jarzmik wrote:
> Philipp Zabel <philipp.zabel@gmail.com> writes:
> 
> > On Thu, May 28, 2009 at 10:59 AM, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> >> On Thu, May 28, 2009 at 07:15:16AM +0200, Philipp Zabel wrote:
> >>> The V3 regulator can be configured with an external resistor
> >>> connected to the feedback pin (R24 in the data sheet) to
> >>> increase the voltage range.
> >>>
> >>> For example, hx4700 has R24 = 3.32 kOhm to achieve a maximum
> >>> V3 voltage of 1.55 V which is needed for 624 MHz CPU frequency.
> >>>
> >>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> >>
> >> Looks good.
> >>
> >> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > Thanks, but it turns out I hit a 32 bit integer overflow in
> > the gain calculation. I'd like to mend that with the following
> > patch. Now max_uV could be increased up to 4.294 V, enough to
> > charge LiPo cells.
> >
> > Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> OK.
> 
> With that one melt into the previous one, have my :
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> Would you submit that to Liam or Mark for queuing into the regulator patch queue ?
> 

Both patches now applied.

Thanks

Liam


