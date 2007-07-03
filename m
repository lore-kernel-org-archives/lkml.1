Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXGCTP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXGCTP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXGCTPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:15:17 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59804 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbXGCTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:15:15 -0400
Date: Tue, 3 Jul 2007 21:15:13 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Nobin Mathew" <nobin.mathew@gmail.com>
Cc: "Midhun Agnihotram" <agnimidhun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: platform_driver_register() ??
Message-ID: <20070703211513.5245946b@poseidon.drzeus.cx>
In-Reply-To: <8d6898730707030558o5e110b0v257ffc6350c76069@mail.gmail.com>
References: <4dde4acb0707030028p2c078a22jd537853f145c2518@mail.gmail.com>
	<8d6898730707030558o5e110b0v257ffc6350c76069@mail.gmail.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.11.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 18:28:40 +0530
"Nobin Mathew" <nobin.mathew@gmail.com> wrote:

> Hi Midhun,
>     I think mmc driver is layered modules, only top block driver
> registers driver under  "mmc_bus_type" bus, see
> drivers/mmc/mmc_sysfs.c and mmc_block.c. I think they are creating a
> tree of devices of same characteristics under that bus.
> I think your driver is linux/drivers/mmc/imxmmc.c where it registers a
> driver for device of type "platform_bus_type". This module will come
> under above mentioned block driver.
> Corresponding platform device is registered in
> linux/arch/arm/mach-imx/generic.c see platform_device imx_mmc_device.
> 

Indeed. You seem to have the hang of this ;)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
