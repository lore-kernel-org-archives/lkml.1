Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYACITt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYACITt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYACITj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:19:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34581 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYACITj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:19:39 -0500
Date: Thu, 3 Jan 2008 09:19:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: murtuja bharmal <murtuja_bharmal@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6  KBUILD Help Required.
Message-ID: <20080103081940.GA16597@uranus.ravnborg.org>
References: <127978.95127.qm@web95102.mail.in2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <127978.95127.qm@web95102.mail.in2.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 01:45:32PM +0530, murtuja bharmal wrote:
> Hello,
> 
>           I have a one question.
>           If I have to add  additional external flag on my external kernel module source during compilation with KBUILD.
>           lest say I have one kernel module file hello.c
>           and I want to add one flag -D testdebug.
>          
>         suppose this is my makefile.
> 
> obj-m += hello.o
> all:
>  make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
> clean:
>  make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
> 
> where I can add this flag.

>From Documentation/kbuild/makefile.txt:
--- 3.7 Compilation flags

    ccflags-y, asflags-y and ldflags-y
        The three flags listed above applies only to the kbuild makefile
        where they are assigned. They are used for all the normal
        cc, as and ld invocation happenign during a recursive build.
        Note: Flags with the same behaviour were previously named:
        EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
        They are yet supported but their use are deprecated.

        ccflags-y specifies options for compiling C files with $(CC).

        Example:
                # drivers/sound/emu10k1/Makefile
                ccflags-y += -I$(obj)
                ccflags-$(DEBUG) += -DEMU10K1_DEBUG


	Sam
