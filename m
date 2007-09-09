Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbXIIV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbXIIV7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXIIV71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:59:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:39083 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXIIV70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NzXb8bD66Xy9d3qtRgHU0JwpVNUxm0ki5xRqTFhLwoIIO8d5sgMtjVG1BBsznBj2XnKgFH68F/t8qQDyNrIFph8V59b7l+z4E3SP2v3oySj1XD6S+BfsRrROZue31botI+TSI58RZcN+x6NRtU6sD4fJKmcSUkpMPZah38Dzqw8=
Message-ID: <46E46BED.4040907@gmail.com>
Date: Mon, 10 Sep 2007 01:55:57 +0400
From: Vladimir Shebordaev <vladimir.shebordaev@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: development.jim@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: USB and MMC device problems on Kernel 2.6.22
References: <46E32207.6080104@gmail.com>
In-Reply-To: <46E32207.6080104@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

development.jim@gmail.com пишет:
> Sorry for not clear about the kernel version, let me try again:
> 
> I have an ARM hardware board works fine with USB and MMC on kernel 
> 2.6.11. Now, I've just upgraded it to kernel 2.6.22. The modules seem 
> loaded fine, please see following list, but neither USB nor MMC could 
> detect devices when a USB stick or SD card was plugged in (I enabled 
> module debug, but nothing printed out, no device node created in /dev). 
> It seems some processes were not running, but I can see usbd and mmcd 
> were running at following list, or what is missing?
> 
> 
> K22 $ ps
>   PID  Uid     VmSize Stat Command
>     1 root        268 S   init
>     2 root            SW< [kthreadd]
>     3 root            SWN [ksoftirqd/0]
>     4 root            SW< [events/0]
>     5 root            SW< [khelper]
>    31 root            SW< [kblockd/0]
>    32 root            SW< [ksuspend_usbd]
>    35 root            SW< [khubd]
>    37 root            SW< [kseriod]
>    49 root            SW  [pdflush]
>    50 root            SW  [pdflush]
>    51 root            SW< [kswapd0]
>    52 root            SW< [aio/0]
>   638 root            SW< [kapmd]
>   670 root            SW< [mtdblockd]
>   693 root            SW< [s3c2410-spi.1]
>   710 root            SW< [kbd_queue/0]
>   746 root            SW< [kmmcd]
>   775 root        644 S   /bin/inetd -f
>   776 root        404 S   /bin/sh
>   790 root        324 R   ps
> 

But does anything show up in syslog?

> I understand that the devfs is no longer supported by the kernel 2.6.22, 
> but should the modules still be able to detect the devices? I manually 
> created nodes on /dev tree such as /dev/mmc /dev/scsi before building 
> and downloading to the target. Any clues please?

Please also make sure you've got decent udev running and properly 
configured.

> 
> K22 $ lsmod
> Module                  Size  Used by
> nls_utf8                1696  0
> nls_iso8859_1           3936  0
> nls_cp437               5600  0
> nls_ascii               3936  0
> vfat                   10336  0
> fat                    48028  1 vfat
> mmc_block               8580  0
> s3c2410mci              6560  0
> mmc_core               25876  2 mmc_block,s3c2410mci
> 
> 
> Thank you.
> 
> Jim

In the hope it helps.

Regards,
Vladimir

