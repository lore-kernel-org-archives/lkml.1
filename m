Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYJGAI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYJGAI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYJGAIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:08:19 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:52261 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYJGAIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:08:19 -0400
Date: Tue, 7 Oct 2008 03:08:02 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC][PATCH 4/5] OMAP SSI integration into misc drivers
Message-ID: <20081007000800.GG8273@frodo>
Reply-To: me@felipebalbi.com
References: <1223034606.32631.156.camel@groo.research.nokia.com> <1223034750-18690-1-git-send-email-carlos.chinea@nokia.com> <1223034750-18690-2-git-send-email-carlos.chinea@nokia.com> <1223034750-18690-3-git-send-email-carlos.chinea@nokia.com> <1223034750-18690-4-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223034750-18690-4-git-send-email-carlos.chinea@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 02:52:29PM +0300, Carlos Chinea wrote:
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  drivers/misc/Kconfig  |    2 ++
>  drivers/misc/Makefile |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index f0202ee..b09dc68 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -488,4 +488,6 @@ config SGI_GRU_DEBUG
>  	This option enables addition debugging code for the SGI GRU driver. If
>  	you are unsure, say N.
>  
> +source "drivers/misc/ssi/Kconfig"
> +
>  endif # MISC_DEVICES
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index b6167e7..39e153d 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -31,3 +31,4 @@ obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
>  obj-$(CONFIG_SGI_XP)		+= sgi-xp/
>  obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
>  obj-$(CONFIG_HP_ILO)		+= hpilo.o
> +obj-$(CONFIG_OMAP_SSI)		+= ssi/

I believe the whole ssi should sit under drivers/ssi

-- 
balbi
