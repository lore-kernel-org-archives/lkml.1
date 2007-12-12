Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbXLLPbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbXLLPbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbXLLPbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:31:32 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:48024 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbXLLPbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:31:31 -0500
Message-ID: <fa686aa40712120731y39a89b84m7f356ebd9c623dce@mail.gmail.com>
Date: Wed, 12 Dec 2007 08:31:30 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Michal Simek" <Monstr@seznam.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: uartlite driver
In-Reply-To: <3454.6513-24750-698925460-1197275267@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3454.6513-24750-698925460-1197275267@seznam.cz>
X-Google-Sender-Auth: 224044e6b16c7f5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/07, Michal Simek <Monstr@seznam.cz> wrote:
> Hi Grant,

Hi Michal,

Sorry I didn't reply right away, got tied up with other stuff.

> I looked at your patches around uartlite. I have tryied to compile this driver for Microblaze
> platform. I use the latest kernel from kernel.org with old uartlite(in front of
> your patches) as stable version and seems to works well.
>
> But I would like to use the latest uartlite driver with your patches.
>
> I have error section type conflict which relates to uartlite driver
> and the second are warnings with Section mismatch.
>
> I look at warnings Section mismatch: reference to on ARM mailing list but
> conclusion is weird.
>
> Can you help me with these problems especially with uartlite?
>
> Important part of log is below.

I don't understand what I'm seeing here.  It looks like you're running
make multiple times and each time the error message changes.  Is that
correct?

Off the top of my head, it looks like you're having problems with
functions labeled as __init; at least in the uartlite driver.

What patches in particular of mine are you having problems with?

Cheers,
g.

>
> Regards,
> Michal Simek
>
>
>
>   CC      drivers/serial/serial_core.o
>   CC      drivers/serial/uartlite.o
> drivers/serial/uartlite.c: In function `ulite_console_setup':
> drivers/serial/uartlite.c:404: error: ulite_console_setup causes a section type conflict
> make[2]: *** [drivers/serial/uartlite.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> [microblaze@monstr linux-2.6-last]$ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   CC      drivers/serial/uartlite.o
> drivers/serial/uartlite.c: In function `ulite_console_init':
> drivers/serial/uartlite.c:451: error: ulite_console_init causes a section type conflict
> make[2]: *** [drivers/serial/uartlite.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> [microblaze@monstr linux-2.6-last]$ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   CC      drivers/serial/uartlite.o
> drivers/serial/uartlite.c: In function `ulite_assign':
> drivers/serial/uartlite.c:486: error: ulite_assign causes a section type conflict
> make[2]: *** [drivers/serial/uartlite.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> [microblaze@monstr linux-2.6-last]$ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   CC      drivers/serial/uartlite.o
> drivers/serial/uartlite.c: In function `ulite_release':
> drivers/serial/uartlite.c:542: error: ulite_release causes a section type conflict
> make[2]: *** [drivers/serial/uartlite.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> [microblaze@monstr linux-2.6-last]$ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   CC      drivers/serial/uartlite.o
> drivers/serial/uartlite.c: In function `ulite_probe':
> drivers/serial/uartlite.c:560: error: ulite_probe causes a section type conflict
> make[2]: *** [drivers/serial/uartlite.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> [microblaze@monstr linux-2.6-last]$ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   CC      drivers/serial/uartlite.o
> drivers/serial/uartlite.c: In function `ulite_of_probe':
> drivers/serial/uartlite.c:594: error: ulite_of_probe causes a section type conflict
> make[2]: *** [drivers/serial/uartlite.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> [microblaze@monstr linux-2.6-last]$ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   CC      drivers/serial/uartlite.o
> drivers/serial/uartlite.c: In function `ulite_init':
> drivers/serial/uartlite.c:659: error: ulite_init causes a section type conflict
> make[2]: *** [drivers/serial/uartlite.o] Error 1
> make[1]: *** [drivers/serial] Error 2
> make: *** [drivers] Error 2
> [microblaze@monstr linux-2.6-last]$ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   CC      drivers/serial/uartlite.o
>   LD      drivers/serial/built-in.o
> ...
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x44): Section mismatch: reference to .init.text:start_kernel (between '_start' and 'run_init_process')
> WARNING: vmlinux.o(.text+0xc9c): Section mismatch: reference to .init.text:early_init_devtree (between 'machine_early_init' and 'machine_restart')
> WARNING: vmlinux.o(.text+0xca8): Section mismatch: reference to .init.data:default_command_line (between 'machine_early_init' and 'machine_restart')
> WARNING: vmlinux.o(.text+0xd8798): Section mismatch: reference to .init.text:uart_parse_options (between 'ulite_console_setup' and 'ulite_console_init')
> WARNING: vmlinux.o(.text+0xd87bc): Section mismatch: reference to .init.text:uart_set_options (between 'ulite_console_setup' and 'ulite_console_init')
>   GEN     .version
>   CHK     include/linux/compile.h
> dnsdomainname: Host name lookup failure
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
>   SYSMAP  System.map
>   OBJCOPY arch/microblaze/boot/linux.bin
> Kernel: arch/microblaze/boot/linux.bin is ready  (#7)
>   Building modules, stage 2.
>   MODPOST 0 modules
>


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
