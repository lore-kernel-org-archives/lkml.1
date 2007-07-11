Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbXGKQCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbXGKQCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbXGKQCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:02:22 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58111 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778AbXGKQCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:02:21 -0400
Date: Wed, 11 Jul 2007 18:02:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Gert Vervoort <gert.vervoort@hccnet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22: dvb header files break compilation on x86-64
Message-ID: <20070711160254.GH3492@stusta.de>
References: <4691F8D6.30600@hccnet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4691F8D6.30600@hccnet.nl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 10:59:02AM +0200, Gert Vervoort wrote:
>
> Some of the linux/dvb header files include libc header files and break 
> compilation on x86-64 in compat_ioctl.c:
>
>
>   CC      fs/timerfd.o
>   CC      fs/eventfd.o
>   CC      fs/compat.o
>   CC      fs/compat_ioctl.o
> In file included from fs/compat_ioctl.c:111:
> include/linux/dvb/audio.h:27:20: error: stdint.h: No such file or directory
> In file included from fs/compat_ioctl.c:112:
> include/linux/dvb/dmx.h:28:18: error: time.h: No such file or directory
> make[1]: *** [fs/compat_ioctl.o] Error 1
> make: *** [fs] Error 2
> [root@apollo linux-2.6.x]#

According to the line numbers your build is pulling a version of the 
header cleaned for userspace.

Does this happen with a freshly unpacked vanilla 2.6.22 kernel from 
ftp.kernel.org?

Please send the first 50 lines of the file include/linux/dvb/audio.h in 
your kernel sources.

What is the output of "make V==1" for fs/compat_ioctl.o?

>    Gert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

