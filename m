Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXBTNTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXBTNTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964862AbXBTNTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:19:11 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36945 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964857AbXBTNTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:19:10 -0500
Date: Tue, 20 Feb 2007 14:19:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BACKLIGHT_CLASS_DEVICE=y, SYSFS=n compile error
Message-ID: <20070220131908.GT13958@stusta.de>
References: <20070220000829.GO13958@stusta.de> <1171975120.5884.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171975120.5884.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 12:38:40PM +0000, Richard Purdie wrote:
> On Tue, 2007-02-20 at 01:08 +0100, Adrian Bunk wrote:
> > CONFIG_BACKLIGHT_CLASS_DEVICE=y, CONFIG_SYSFS=n results int he 
> > following compile error:
> > ...
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `nvidia_bl_exit':
> > (.text+0x27d01): undefined reference to `backlight_device_unregister'
> > drivers/built-in.o: In function `nvidia_bl_init':
> > (.text+0x27e3c): undefined reference to `backlight_device_register'
> 
> I've added the patch below to the git backlight tree to resolve this.

Thanks, I can confirm this fixes it.

> Cheers,
> 
> Richard
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

