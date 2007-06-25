Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbXFYUti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbXFYUti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXFYUtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:49:31 -0400
Received: from smtp.avagotech.com ([202.153.6.34]:56532 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXFYUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:49:30 -0400
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 16:49:30 EDT
Message-ID: <46802222.90104@lpbroadband.net>
Date: Mon, 25 Jun 2007 14:14:26 -0600
From: Frank Bennett <bennett78@lpbroadband.net>
Reply-To: bennett78@lpbroadband.net
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kernel@avr32linux.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AVR32 fixes
References: <20070623164143.2bba7104@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070623164143.2bba7104@dhcp-255-175.norway.atmel.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:T L:E SM:1
X-imss-tmaseResult: TT:1 TS:-13.8630 TC:1F TRN:39 TV:3.6.1039(15260.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:3 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> Hi Linus,
>
> Please pull the 'for-linus' branch of
>
>   git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus
>
> to receive the following updates.
>
> The status of the various SL*B allocators on AVR32 is now as follows:
>   * SLAB works, but debugging is effectively disabled due to
>     ARCH_KMALLOC_MINALIGN.
>   * SLUB works, including debugging.
>   * SLOB seems to ignore ARCH_KMALLOC_MINALIGN, so it breaks DMA
>     (SPI in particular is affected by this.)
>
> So since SLUB is currently the allocator that works best on AVR32, I've
> enabled it by default for both ATSTK1002 and ATNGW100. Big thanks to
> Christoph for fixing the ARCH_KMALLOC_MINALIGN vs. CONFIG_SLUB_DEBUG
> issue.
>
> David Brownell (1):
>       [AVR32] Initialize dma_mask and dma_coherent_mask
>
> Haavard Skinnemoen (2):
>       [AVR32] Fix bug in invalidate_dcache_region()
>       [AVR32] Update defconfigs
>
> ben.nizette@iinet.net.au (1):
>       [AVR32] NGW100, Remove relics of the old USART mapping scheme
>   
snip, snip.....
makes fine, but requires :
export ARCH=avr32
export CROSS_COMPILE=avr32-linux-
make defconfig
make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  MODPOST vmlinux
  UIMAGE arch/avr32/boot/images/uImage
"mkimage" command not found - U-Boot images will not be built
  Image arch/avr32/boot/images/uImage is ready
make[1]: `arch/avr32/boot/images/vmlinux.elf' is up to date.
  Building modules, stage 2.
  MODPOST 20 modules

-Frank Bennett

