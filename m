Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYEYSOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYEYSOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYEYSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:13:56 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59674 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYEYSNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:13:55 -0400
Date: Sun, 25 May 2008 21:11:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
Message-ID: <20080525181118.GG1791@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1211735607.14556.14.camel@mtlp.tischlernetz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 07:13:27PM +0200, Mirco Tischler wrote:
> Hi
> 
> I've got this compilation error on current mainline (x86_64):
> 
> <snip>
> Root device is (8, 5)
> Setup is 12236 bytes (padded to 12288 bytes).
> System is 2497 kB
> CRC d12efd40
> Kernel: arch/x86/boot/bzImage is ready  (#27)
>   Building modules, stage 2.
>   MODPOST 222 modules
> ERROR: "____ilog2_NaN" [drivers/usb/core/usbcore.ko] undefined!
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2
> 
> I attach my config.
> 
> I don't really know who is the right to cc for this. So please feel free to add further cc's.

Works for me with your .config.

You are using an unmodified 2.6.26-rc3 kernel?

If yes, please:
- send the output of "bash ./scripts/ver_linux" and
- your drivers/usb/core/usbcore.o

> Thanks
> 
> Mirco
>...

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

