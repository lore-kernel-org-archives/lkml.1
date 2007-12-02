Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbXLBHFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbXLBHFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 02:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLBHFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 02:05:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbXLBHFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 02:05:23 -0500
Date: Sat, 1 Dec 2007 23:05:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
Subject: Re: blackfin compile error
Message-Id: <20071201230501.dac3b217.akpm@linux-foundation.org>
In-Reply-To: <200712012259.06493.david-b@pacbell.net>
References: <20071202004204.GE15974@stusta.de>
	<386072610712012242i58e48aebk17fec7a87391a7fc@mail.gmail.com>
	<200712012259.06493.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 22:59:05 -0800 David Brownell <david-b@pacbell.net> wrote:

> On Saturday 01 December 2007, Bryan Wu wrote:
> > On Dec 2, 2007 8:42 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > > It seems commit 5d448dd50712ae42f8176b5bb8db4703bef6f0f5 was incomplete:
> > >
> > > <--  snip  -->
> > >
> > > ...
> > >   CC      arch/blackfin/mach-bf537/boards/stamp.o
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: unknown field 'pin_req' specified in initializer
> > 
> > Yes, there is a SPI patch adding the field 'pin_req' in a Blackfin SPI
> > header file which is in -mm tree.
> > 
> > David, could you please submit the Blackfin SPI update to mainline?
> 
> So far as I know they're all ready for Andrew to get them to Linus...
> 

I have all these:

spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
spi-simplify-spi_sync-calling-convention.patch
spi-use-simplified-spi_sync-calling-convention.patch
#
spi-initial-bf54x-spi-support.patch
spi-bfin-spi-uses-portmux-calls.patch
spi-spi_bfin-cleanups-error-handling.patch
spi-spi_bfin-handles-spi_transfercs_change.patch
spi-spi_bfin-dont-bypass-spi-framework.patch
spi-spi_bfin-uses-platform-device-resources.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-handle-multiple-spi_masters.patch
spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch
spi-spi_bfin-update-handling-of-delay-after-deselect.patch
spi-spi_bfin-resequence-dma-start-stop.patch
#
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch

queued for 2.6.25.  If some of them need to be bumped up to 2.6.24: which
ones and why?

