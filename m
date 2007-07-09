Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbXGIJnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbXGIJnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXGIJnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:43:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49970 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbXGIJnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:43:08 -0400
Date: Mon, 9 Jul 2007 10:49:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodney Gordon II <meff@spherevision.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [BUG] IT8212 libata driver *still* hard-freezes system on boot
 on 2.6.22 final.
Message-ID: <20070709104930.4e26f38f@the-village.bc.nu>
In-Reply-To: <1183944204.8932.8.camel@ghreen.sphere>
References: <1183944204.8932.8.camel@ghreen.sphere>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jul 2007 20:23:24 -0500
Rodney Gordon II <meff@spherevision.org> wrote:

> Have been quite busy, and I regret I haven't tried a rc kernel in
> awhile, but, this bug has gone un-fixed still.. Thought I'd throw in
> another "heads up"..
> 
> 2.6.22 hang: http://spherevision.org/sync/visual/itelock.jpg
> lspci -vvv: http://spherevision.org/sync/tmp/lspci.out
> 
> Pentium-D 830 3.0GHz Dualcore on a ASUS P5LD2 with latest bios rev.
> 1804.
> 
> SysRq does not work when this locks up.
> 
> Patches, info, things to try, anything is welcome, I am available for
> awhile now and will try anything to get this working.

I'm at a bit of a loss on this one I'm afraid - it seems to be specific
to a couple of boards and every IT821x box I can lay my paws on works
beautifully.

It would be useful to know if a kernel built with no DMA support for the
IT8212 behaved as that might give us a clue about what is choking. If you
look in drivers/ata/pata_it821x.c:it821x_init_one you'll see a pair of
lines that say

	mwdma = 0x1f,
	udma_mask = 0x7f


remove, rebuild and report..

Thanks
Alan
