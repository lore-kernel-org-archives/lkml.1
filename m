Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbYKZVjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbYKZVjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYKZVjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:39:00 -0500
Received: from ozlabs.org ([203.10.76.45]:49148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYKZVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:39:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18733.49643.63081.163437@cargo.ozlabs.ibm.com>
Date: Thu, 27 Nov 2008 08:38:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: avorontsov@ru.mvista.com
Cc: Trent Piepho <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] of_gpio: Return GPIO flags from of_get_gpio()
In-Reply-To: <20081126162033.GA13397@oksana.dev.rtsoft.ru>
References: <20081030111500.GB22008@oksana.dev.rtsoft.ru>
	<1225418589-8545-1-git-send-email-tpiepho@freescale.com>
	<20081126162033.GA13397@oksana.dev.rtsoft.ru>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov writes:

> Can we apply it? Paul, Benjamin?
> 
> The patchwork url for this patch is:
> http://patchwork.ozlabs.org/patch/6650/
> 
> 
> Thanks!
> 
> >  drivers/mtd/nand/fsl_upm.c              |    2 +-
> >  drivers/net/fs_enet/fs_enet-main.c      |    2 +-
> >  drivers/net/phy/mdio-ofgpio.c           |    4 ++--
> >  drivers/of/gpio.c                       |   13 ++++++++++---
> >  drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
> >  include/linux/of_gpio.h                 |   21 +++++++++++++++++----
> >  6 files changed, 32 insertions(+), 12 deletions(-)

That would need acks from Jeff Garzik and David Woodhouse.

Alternatively you could add a new function (called, for instance,
of_get_gpio_flags) with the extra parameter to eliminate the need to
change any drivers at this stage, since they all seem to pass NULL for
the flags argument.

Paul.
