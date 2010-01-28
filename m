Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191Ab0A1AlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0A1AlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635Ab0A1AlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:41:03 -0500
Received: from trinity.fluff.org ([89.16.178.74]:47993 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0A1AlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:41:00 -0500
Date: Thu, 28 Jan 2010 00:39:14 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: adharmap@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org, Kalle Valo <kalle.valo@iki.fi>,
       Russell King <linux@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jean Pihet <jpihet@mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Tony Lindgren <tony@atomide.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>,
       linux-kernel@vger.kernel.org,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-omap@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Philby John <pjohn@in.mvista.com>, Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 0/5] Arm Gic Changes
Message-ID: <20100128003914.GM9153@trinity.fluff.org>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:32:24AM -0800, adharmap@codeaurora.org wrote:
> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> 
> Few fixes and improvements to arch/arm/common/gic.c file.

both ARM and GIC in the title should be all in capitals, they are
abbreviations of something longer.

I think it would be nicer to make GIC in all the patch titles all capital
instead of all lower case.
 
> Abhijeet Dharmapurikar (5):
>   gic: prevent gic from crossing NR_IRQ
>   gic: add callback for mask_ack
>   gic: Add set_type callback
>   gic: dont disable INT in ack callback
>   gic: initialize interrupts as per argument
> 
>  arch/arm/common/gic.c                    |  114 ++++++++++++++++++++++++-----
>  arch/arm/include/asm/hardware/gic.h      |    3 +-
>  arch/arm/mach-omap2/board-4430sdp.c      |    3 +-
>  arch/arm/mach-realview/realview_eb.c     |   10 ++-
>  arch/arm/mach-realview/realview_pb1176.c |    7 ++-
>  arch/arm/mach-realview/realview_pb11mp.c |    7 ++-
>  arch/arm/mach-realview/realview_pba8.c   |    4 +-
>  arch/arm/mach-realview/realview_pbx.c    |    5 +-
>  arch/arm/mach-ux500/cpu-u8500.c          |    2 +-
>  9 files changed, 122 insertions(+), 33 deletions(-)
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

