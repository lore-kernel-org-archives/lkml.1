Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0CDT0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:26:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37474 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab0CDT0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:26:31 -0500
Date: Thu, 4 Mar 2010 20:26:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: mx1-camera: compile fix
Message-ID: <20100304192623.GA14587@pengutronix.de>
References: <1267721687-19697-1-git-send-email-u.kleine-koenig@pengutronix.de> <Pine.LNX.4.64.1003041811160.4825@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1003041811160.4825@axis700.grange>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Thu, Mar 04, 2010 at 06:13:38PM +0100, Guennadi Liakhovetski wrote:
> > +#undef DMA_BASE 
> > +#define DMA_BASE MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR)
> 
> I don't like this. Why the "undef"? Is DMA_BASE already defined? where and 
> what is it? If it is - we better use a different name, if not - just 
> remove the undef, please.
yes, it's not pretty, but I wanted to make a minimal patch.

arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h has:

	#define DMA_BASE IO_ADDRESS(DMA_BASE_ADDR)

so that was used before.  I don't really know the driver, just made it
compile again.  If you have a nice suggestion, I will happily implement
it.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
