Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYIFMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYIFMYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYIFMXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:23:54 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:58452 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYIFMXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:23:53 -0400
Date: Sat, 6 Sep 2008 14:23:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Greg Ungerer <gerg@snapgear.com>, jbarnes@virtuousgeek.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [2.6 patch] m68k: remove the dead PCI code
In-Reply-To: <20080831161016.GE3695@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0809061422510.4138@anakin>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com>
 <20080825204333.GA13027@cs181140183.pp.htv.fi> <48B77764.6060607@snapgear.com>
 <20080829070103.GD16462@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0808290929280.22326@anakin>
 <20080831161016.GE3695@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008, Adrian Bunk wrote:
> This patch removes the no longer used m68k PCI code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> --- a/include/asm-m68k/pci.h
> +++ b/include/asm-m68k/pci.h

> -/* The PCI address space does equal the physical memory
> - * address space.  The networking and block device layers use
> - * this boolean for bounce buffer decisions.
> - */

I'd like to keep this comment, as the #define is still there.
Is that OK for you?

>  #define PCI_DMA_BUS_IS_PHYS	(1)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
