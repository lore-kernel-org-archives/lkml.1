Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbXD0MOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbXD0MOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbXD0MOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:14:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:7121 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXD0MOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=bhJPY2dPNILfq07mEc/z2FDhGMU7pfIi0KNReW+WNFC/ylIJD3k+hIe7W9MfSkreW/wJRy6tCZ6FPXSAsF/zyI3y/ZhlczghoLM0HwjqwG9npBq0gcom6w1Ptfhe4rqOnuY9A5Wh0f7KZnrT7QaGfjf8n5VvJYslC9UUJGCeE9Y=
Message-ID: <4631E93A.1010404@gmail.com>
Date: Fri, 27 Apr 2007 15:14:50 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <603217.22031.qm@web36713.mail.mud.yahoo.com>
In-Reply-To: <603217.22031.qm@web36713.mail.mud.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> As I already said, I'm not aware of any issues with version 0.8 of the driver. If you have any
> problems with it, I'll be glad to fix them.
>
> The version in question was recently committed into the -mm tree. Otherwise, it's available from
> the project's website for a couple of months now:

It seems a bit out-of-date. Here is the output:

build-i386-sony-tx770p$ make
scripts/kconfig/conf -s arch/i386/Kconfig
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  CC [M]  drivers/misc/tifm_core.o
  CC [M]  drivers/misc/tifm_7xx1.o
  CC [M]  drivers/mmc/tifm_sd.o
drivers/mmc/tifm_sd.c: In function ‘tifm_sd_probe’:
drivers/mmc/tifm_sd.c:987: error: ‘struct mmc_host’ has no member named 
‘max_sectors’
make[2]: *** [drivers/mmc/tifm_sd.o] Error 1
make[1]: *** [drivers/mmc] Error 2
make: *** [drivers] Error 2

This is with v2.6.21 and your tarball unpacked like this:
linux/tifm.h -> include/linux/tifm.h
tifm_sd.c -> drivers/mmc/tifm_sd.c
tifm_7xx1.c -> drivers/misc/tifm_7xx1.c
tifm_core.c -> drivers/misc/tifm_core.c

I will look in mm and write back.
