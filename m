Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbXF2Ph3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbXF2Ph3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXF2PhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:37:16 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:59263 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbXF2PhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:37:14 -0400
Date: Fri, 29 Jun 2007 17:38:35 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070629153835.GN13886@enneenne.com>
References: <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183130716.1170.347.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183130716.1170.347.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 04:25:16PM +0100, David Woodhouse wrote:
> On Fri, 2007-06-29 at 17:08 +0200, Rodolfo Giometti wrote:
> > On Fri, Jun 29, 2007 at 12:38:02PM +0100, David Woodhouse wrote:
> > > 
> > > It doesn't apply to the current git tree, which has already had some new
> > > system calls added.
> > 
> > Ok, here the patch against latest git commit.
> 
>   CC      fs/fcntl.o
> In file included from include/linux/syscalls.h:69,
>                  from fs/fcntl.c:8:
> include/linux/pps.h:51: error: field ???tspec??? has incomplete type
> make[1]: *** [fs/fcntl.o] Error 1

Gulp! =:-o

On my system I get:

   giometti@zaigor:~/Projects/linuxpps/kernel$ touch fs/fcntl.c 
   giometti@zaigor:~/Projects/linuxpps/kernel$ make
     CHK     include/linux/version.h
     CHK     include/linux/utsrelease.h
     CALL    scripts/checksyscalls.sh
     CHK     include/linux/compile.h
     CC      fs/fcntl.o
     LD      fs/built-in.o
     GEN     .version
     CHK     include/linux/compile.h
     UPD     include/linux/compile.h
     CC      init/version.o
     LD      init/built-in.o
     LD      .tmp_vmlinux1
     KSYM    .tmp_kallsyms1.S
     AS      .tmp_kallsyms1.o
     LD      .tmp_vmlinux2
     KSYM    .tmp_kallsyms2.S
     AS      .tmp_kallsyms2.o
     LD      vmlinux
     SYSMAP  System.map
     SYSMAP  .tmp_System.map
     MODPOST vmlinux
   WARNING: arch/i386/kernel/built-in.o(.exit.text+0x18): Section mismatch: reference to .init.text: (after 'cache_remove_dev')
   WARNING: kernel/built-in.o(.text+0x13826): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
     AS      arch/i386/boot/setup.o
     LD      arch/i386/boot/setup
     OBJCOPY arch/i386/boot/compressed/vmlinux.bin
     GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
     LD      arch/i386/boot/compressed/piggy.o
     LD      arch/i386/boot/compressed/vmlinux
     OBJCOPY arch/i386/boot/vmlinux.bin
     BUILD   arch/i386/boot/bzImage
   Root device is (9, 0)
   Boot sector 512 bytes.
   Setup is 7057 bytes.
   System is 1348 kB
   Kernel: arch/i386/boot/bzImage is ready  (#135)
     Building modules, stage 2.
     MODPOST 69 modules

How is that possible??? I just git pull the linux code... maybe you
have a bit older version?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
