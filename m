Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbYJHRS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbYJHRS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYJHRSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:18:21 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:35405 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbYJHRSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:18:20 -0400
Date: Wed, 8 Oct 2008 19:18:15 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: [patch 2.6.27-rc8-git] add drivers/mfd/twl4030-core.c
Message-ID: <20081008171814.GB4766@localdomain>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <200810061047.50127.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810061047.50127.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, Oct 06, 2008 at 10:47:49AM -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> This patch adds the core of the TWL4030 driver, which supports
> chips including the TPS65950.  These chips are multi-function; see 
> 
>   http://focus.ti.com/docs/prod/folders/print/tps65950.html
> 
> Public specs are in the works.  For now, the block diagram on
> the second page of the datasheet is fairly informative.
> 
> There are some known issues with this core code.  Most notably,
> the IRQ dispatching needs simplification (to use more of genirq),
> generalization (integrating support for secondary IRQ dispatch
> as well as primary, and removing the build dependency on OMAP),
> and then probably updating to leverage threaded IRQ support
> (expected to arrive in mainline "soon").
> 
> Once the core is in mainline, drivers for other parts of this
> chip can follow its lead and start swimming upstream too.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Thanks, applied to my mfd tree.


> +#if defined(CONFIG_TWL4030_BCI_BATTERY) || \
> +	defined(CONFIG_TWL4030_BCI_BATTERY_MODUEL)
minor typo, you probably meant: CONFIG_TWL4030_BCI_BATTERY_MODULE

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
