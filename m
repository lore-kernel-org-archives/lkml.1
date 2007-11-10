Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbXKJJMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbXKJJMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 04:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXKJJLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 04:11:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44269 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXKJJLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 04:11:50 -0500
Date: Sat, 10 Nov 2007 09:10:57 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Schwebel <robert@schwebel.de>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: ARM defconfig bogosity in current git
Message-ID: <20071110091057.GA10446@flint.arm.linux.org.uk>
References: <20071110080629.GA18520@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110080629.GA18520@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 05:06:29PM +0900, Paul Mundt wrote:
> The last ARM merge contained this gem:
> 
> commit f33bac8dd4573428b94c67149c5607be489092d1
> Author: Robert Schwebel <robert@schwebel.de>
> Date:   Mon Nov 5 17:59:25 2007 +0100
> 
>     [ARM] 4642/2: netX: default config for netx based boards
>     
>     This patch updates the default config file for netx based boards.
>     
>     Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
>     Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> diff --git a/arm/configs/netx_defconfig b/arm/configs/netx_defconfig
> new file mode 100644
> index 0000000..57f32f3
> --- /dev/null
> +++ b/arm/configs/netx_defconfig
> 
> ...
> 
> Isn't there something in Documentation/ about -p1 being a good idea
> precisely so this sort of silliness is avoided?

-p1 doesn't avoid this when the patch just contains new files.
Unfortunately, you have to rely both on people spotting such things
and whoever's generating the patch doing the right thing.

There will be times when things slip through though.

> Currently this breaks tab completion on arch/, which is very much a
> regression ;-)

Robert?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
