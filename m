Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbZFLM7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbZFLM7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbZFLMzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:55:53 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:34986 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964AbZFLMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:55:52 -0400
Date: Fri, 12 Jun 2009 14:55:51 +0200
From: Daniel Mack <daniel@caiaq.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3: add click function
Message-ID: <20090612125550.GF29236@buzzloop.caiaq.de>
References: <20090612101805.GC18682@elf.ucw.cz> <1244803042-2913-1-git-send-email-daniel@caiaq.de> <4A323FB4.1090404@tremplin-utc.net> <20090612123156.GE29236@buzzloop.caiaq.de> <4A324F00.7020602@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A324F00.7020602@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 02:50:08PM +0200, Éric Piel wrote:
> > static struct spi_board_info my_spi_devices[] __initdata = {
> >         {
> >                 .modalias       = "lis3lv02d_spi",
> >                 .max_speed_hz   = 1000000,
> >                 .bus_num        = 0,
> >                 .chip_select    = 0,
> >                 .controller_data = (void *) mfp_to_gpio(GPIO_ACCEL_CS),
> >                 .platform_data  = &lis3_pdata,
> >                 .irq            = gpio_to_irq(mfp_to_gpio(GPIO_ACCEL_IRQ)),
> >         },
> > 
> I see. So your platform is not among the one contained in the vanilla
> kernel? Shouldn't this above code be written somewhere so that people
> know about it? Some of the values do not seem especially obvious!

The platform is currently under development and will be merged at some
later point. The magics above are just GPIO defintions - everything
else is just the usual glue logic you add when registering an SPI
device.

> > We're using the IRQ outputs of that chips directly as source to other
> > circuity, so there is no userspace logic in the game. If anyone needs
> > that, a simple callback function would be easy to add at some later
> > point.
> I guess that to have the functionality in ACPI, a complete handling of
> the interruptions, up to the generation of button events would be
> needed. This can be done later on, whenever someone finds the need...

Ack.

> Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

Thanks :)

Andrew, could you queue that one?

Daniel
