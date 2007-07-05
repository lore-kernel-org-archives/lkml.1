Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbXGEJVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbXGEJVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbXGEJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:21:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:30263 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbXGEJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AUjHXoG1yR7b0Bdl9gfK6sytD8IRCDvx+Pn+I9mpoeL73z2UqqtMAnj8lZ3E1D6TLxKuiTNjUR5087OWd0MF/gNvC0pjSIkeMU90C11EMFw+XD7whM19pJ3B484G6rdK+t8jiFeYf8H3h7EGH6sHQERornsk4Mkz1/NPracfTRQ=
Message-ID: <4dde4acb0707050221k5a73a4abt2db9e8b0f7c74ae1@mail.gmail.com>
Date: Thu, 5 Jul 2007 14:51:35 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: platform_driver_register() ??
Cc: "Nobin Mathew" <nobin.mathew@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070703211513.5245946b@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0707030028p2c078a22jd537853f145c2518@mail.gmail.com>
	 <8d6898730707030558o5e110b0v257ffc6350c76069@mail.gmail.com>
	 <20070703211513.5245946b@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,


> >     I think mmc driver is layered modules, only top block driver
> > registers driver under  "mmc_bus_type" bus, see
> > drivers/mmc/mmc_sysfs.c and mmc_block.c. I think they are creating a
> > tree of devices of same characteristics under that bus.
> > I think your driver is linux/drivers/mmc/imxmmc.c where it registers a
> > driver for device of type "platform_bus_type". This module will come
> > under above mentioned block driver.
> > Corresponding platform device is registered in
> > linux/arch/arm/mach-imx/generic.c see platform_device imx_mmc_device.


    Is it necessary that the firmware (may be bootloader) notify about
the MMC host to Linux? The kernel documentation (platform.txt) says :

 "The firmware should notify the platform bus about devices before the
legacy drivers have had a chance to load."

   Have I interpreted the above sentence correctly?

Thanks,
Midhun.
