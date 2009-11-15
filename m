Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbZKOWpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbZKOWpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZKOWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:45:17 -0500
Received: from mga10.intel.com ([192.55.52.92]:52963 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305AbZKOWpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:45:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,747,1249282800"; 
   d="scan'208";a="514116126"
Date: Sun, 15 Nov 2009 23:47:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove default selection of AB4500
Message-ID: <20091115224708.GE8367@sortiz.org>
References: <1258058667-16722-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258058667-16722-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Nov 12, 2009 at 09:44:27PM +0100, Linus Walleij wrote:
> This remove the default 'y' selection of AB4500, currently everyone
> enabling the SPI subsystem will get a copy of this driver.
Applied, many thanks.

Cheers,
Samuel.


> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> ---
>  drivers/mfd/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b1d5370..b46b11b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -342,7 +342,6 @@ config MFD_88PM8607
>  config AB4500_CORE
>  	tristate "ST-Ericsson's AB4500 Mixed Signal Power management chip"
>  	depends on SPI
> -	default y
>  	help
>  	  Select this option to enable access to AB4500 power management
>  	  chip. This connects to U8500 on the SSP/SPI bus and exports
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
