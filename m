Return-Path: <linux-kernel-owner+w=401wt.eu-S1031787AbXEEPeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031787AbXEEPeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031791AbXEEPeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:34:25 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031787AbXEEPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:34:23 -0400
Date: Sat, 5 May 2007 11:28:51 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 4/10] ARM: OMAP: gpio init section cleanups
Message-ID: <20070505102850.GA22729@flint.arm.linux.org.uk>
Mail-Followup-To: Tony Lindgren <tony@atomide.com>,
	linux-kernel@vger.kernel.org,
	David Brownell <dbrownell@users.sourceforge.net>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com> <11761525022200-git-send-email-tony@atomide.com> <20070505100426.GA9943@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505100426.GA9943@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 11:04:26AM +0100, Russell King wrote:
> On Mon, Apr 09, 2007 at 05:01:06PM -0400, Tony Lindgren wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Minor GPIO cleanups:  remove needless #include, and omap_gpio_init()
> > should be __init, as well as all the board init code calling it.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> I've applied 8 patches from this series by cherry picking it from your
> git tree, minus this patch which git wouldn't apply due to fuzz in
> arch/arm/plat-omap/gpio.c.

Incidentally, when doing a build after these patches, I'm seeing:

arch/arm/plat-omap/dma.c: In function `omap_get_dma_src_pos':
arch/arm/plat-omap/dma.c:750: warning: 'offset' might be used uninitialized in this function
arch/arm/plat-omap/dma.c: In function `omap_get_dma_dst_pos':
arch/arm/plat-omap/dma.c:772: warning: 'offset' might be used uninitialized in this function

These look like they're valid warnings to me.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
