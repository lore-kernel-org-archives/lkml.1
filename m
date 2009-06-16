Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbZFPSdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbZFPSdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZFPSdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:33:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZFPSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:33:22 -0400
Message-ID: <4A37B65A.3070108@zytor.com>
Date: Tue, 16 Jun 2009 08:12:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp>
In-Reply-To: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
> 
> I tried to build 03347e2592078a90df818670fddf97a33eec70fb and got this error.
> 
> (...snipped...)
> WARNING: modpost: Found 2 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> /usr/src/all/linux/kernel/git/torvalds/linux-2.6.git/usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
> /usr/src/all/linux/kernel/git/torvalds/linux-2.6.git/usr/include/mtd/jffs2-user.h:21: userspace cannot call function or variable defined in the kernel
> Documentation/accounting/getdelays.c: In function `main':
> Documentation/accounting/getdelays.c:249: warning: `cmd_type' might be used uninitialized in this function
> Documentation/spi/spidev_fdx.c: In function `do_msg':
> Documentation/spi/spidev_fdx.c:61: warning: cast from pointer to integer of different size
> Documentation/spi/spidev_fdx.c:64: warning: cast from pointer to integer of different size
> arch/x86/boot/bioscall.S: Assembler messages:
> arch/x86/boot/bioscall.S:68: Error: `68(%esp)' is not a valid 16 bit base/index expression
> make[1]: *** [arch/x86/boot/bioscall.o] Error 1
> make: *** [bzImage] Error 2
> 
> # gcc --version
> gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)
> Copyright (C) 2003 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 

What version of binutils do you have?

What you're seeing is a bug in gas.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

