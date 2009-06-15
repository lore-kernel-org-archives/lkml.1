Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbZFONXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbZFONXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZFONWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:22:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57235 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbZFONWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:22:52 -0400
Date: Mon, 15 Jun 2009 15:22:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream
	device
Message-ID: <20090615132248.GB14555@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <1245033557-10968-3-git-send-email-swetland@google.com> <1245033557-10968-4-git-send-email-swetland@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245033557-10968-4-git-send-email-swetland@google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Signed-off-by: Brian Swetland <swetland@google.com>
> ---
>  arch/arm/mach-msm/Kconfig       |    6 ++
>  arch/arm/mach-msm/Makefile      |    1 +
>  arch/arm/mach-msm/board-dream.c |  113 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/board-dream.h |    5 ++
>  4 files changed, 125 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/board-dream.c
>  create mode 100644 arch/arm/mach-msm/board-dream.h

Thanks for renaming the board-* files...

> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 35f2a90..f780086 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -34,4 +34,10 @@ config MACH_HALIBUT
>  	help
>  	  Support for the Qualcomm SURF7201A eval board.
>  
> +config MACH_TROUT
> +	default y
> +	bool "HTC Dream (aka trout)"
> +	help
> +	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> +
>  endif

...but I guess renaming config option makes sense too..

> +static void __init trout_init_irq(void)
> +{
> +	msm_init_irq();
> +}

...and most occurences of trout, here, too... (I'm not sure if some
are required for compatibility with existing userland?)
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
