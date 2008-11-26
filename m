Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYKZWcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYKZWcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYKZWb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:31:56 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:25882 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752302AbYKZWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:31:55 -0500
Date: Thu, 27 Nov 2008 01:31:51 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Trent Piepho <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] of_gpio: Return GPIO flags from of_get_gpio()
Message-ID: <20081126223151.GA1178@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081030111500.GB22008@oksana.dev.rtsoft.ru> <1225418589-8545-1-git-send-email-tpiepho@freescale.com> <20081126162033.GA13397@oksana.dev.rtsoft.ru> <18733.49643.63081.163437@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <18733.49643.63081.163437@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 08:38:51AM +1100, Paul Mackerras wrote:
[...]
> > >  drivers/mtd/nand/fsl_upm.c              |    2 +-
> > >  drivers/net/fs_enet/fs_enet-main.c      |    2 +-
> > >  drivers/net/phy/mdio-ofgpio.c           |    4 ++--
> > >  drivers/of/gpio.c                       |   13 ++++++++++---
> > >  drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
> > >  include/linux/of_gpio.h                 |   21 +++++++++++++++++----
> > >  6 files changed, 32 insertions(+), 12 deletions(-)
> 
> That would need acks from Jeff Garzik and David Woodhouse.
> 
> Alternatively you could add a new function (called, for instance,
> of_get_gpio_flags) with the extra parameter to eliminate the need to
> change any drivers at this stage, since they all seem to pass NULL for
> the flags argument.

:-))

This was _exactly_ my initial approach, but Trent and Grant thought
that changing API would be easy. Hah-ha!

Here is my initial patch implementing of_get_gpio_flags():
http://lkml.org/lkml/2008/7/25/236

Trent, are you going to push your patch through all the
maintainers, or should we, after all, revert to my approach
instead?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
