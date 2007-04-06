Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXDFQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXDFQk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbXDFQk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:40:59 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44493 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933253AbXDFQk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:40:58 -0400
Date: Fri, 6 Apr 2007 18:40:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Pedro Mullor =?utf-8?Q?Jim=C3=A9nez?= <pmullor@skynet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.9 won't compile
Message-ID: <20070406164058.GK29169@stusta.de>
References: <1175855823.16114.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1175855823.16114.12.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 12:37:03PM +0200, Pedro Mullor Jiménez wrote:
> Dear all,
> 
> I downloaded version 2.6.9 of the kernel from kernel.org
> I went throught menuconfig, importing the configuration of my current
> 2.6.15-28-686.
> 
> I then tried to compile it but the compilation exits with an error
> (below).
> 
> I also tried to do make mrproper, got rid of the .config file, made
> menuconfig again without importing anything, and when compiling it
> failed again.
> 
> The reason for me to use this kernel is because I have a VIA VT82C
> 693A/598/686 chipset and I suffer from perf problems (which google says
> only happen since 2.6.10).

Can you give a pointer or description of this problem?

The preferred solution for you would not be to run an ancient kernel 
with tons of known security holes but to get this problem fixed.

> Might I request to be personally CC'ed in the answers/comments posted in
> response to this post ?
> 
> Many thanks in advance for your comments and help!
> 
> With kind regards,
> Pedro Mullor
> 
> 
>   CHK     include/linux/version.h
> make[1]: `arch/i386/kernel/asm-offsets.s' is up to date.
>   CHK     include/linux/compile.h
>   CC      arch/i386/kernel/process.o
> arch/i386/kernel/process.c: In function ‘show_regs’:
> arch/i386/kernel/process.c:252: warning: pointer targets in passing
> argument 2 of ‘show_trace’ differ in signedness
> {standard input}: Assembler messages:
> {standard input}:813: Error: suffix or operands invalid for `mov'
> {standard input}:814: Error: suffix or operands invalid for `mov'
> {standard input}:1040: Error: suffix or operands invalid for `mov'
> {standard input}:1041: Error: suffix or operands invalid for `mov'
> {standard input}:1121: Error: suffix or operands invalid for `mov'
> {standard input}:1122: Error: suffix or operands invalid for `mov'
> {standard input}:1226: Error: suffix or operands invalid for `mov'
> {standard input}:1227: Error: suffix or operands invalid for `mov'
> {standard input}:1290: Error: suffix or operands invalid for `mov'
> {standard input}:1302: Error: suffix or operands invalid for `mov'
> make[1]: *** [arch/i386/kernel/process.o] Error 1
> make: *** [arch/i386/kernel] Error 2


Older kernels use an assembler syntax no longer supported by recent 
binutils.

A patch is at [1].

cu
Adrian

[1] http://www.kernel.org/pub/linux/devel/binutils/linux-2.6-seg-5.patch

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

