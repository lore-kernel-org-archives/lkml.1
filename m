Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161Ab0AEK1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0AEK1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 05:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076Ab0AEK1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 05:27:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0AEK1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 05:27:09 -0500
Date: Tue, 5 Jan 2010 11:27:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: kernel-janitors@vger.kernel.org, Imre Deak <imre.deak@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       Cory Maccarrone <darkstar6262@gmail.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-fbdev@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] video/omap: add __init/__exit macros to
 drivers/video/omap/lcd_htcherald.c
In-Reply-To: <1261470890-24031-1-git-send-email-peterhuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.1001051126360.2277@pobox.suse.cz>
References: <1261470890-24031-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, peterhuewe@gmx.de wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of
> 
> drivers/video/omap/lcd_htcherald.c
> 
> Please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial
> tree.
> 
> Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
> but also present in linus tree.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/video/omap/lcd_htcherald.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/omap/lcd_htcherald.c b/drivers/video/omap/lcd_htcherald.c
> index a9007c5..4802419 100644
> --- a/drivers/video/omap/lcd_htcherald.c
> +++ b/drivers/video/omap/lcd_htcherald.c
> @@ -115,12 +115,12 @@ struct platform_driver htcherald_panel_driver = {
>  	},
>  };
>  
> -static int htcherald_panel_drv_init(void)
> +static int __init htcherald_panel_drv_init(void)
>  {
>  	return platform_driver_register(&htcherald_panel_driver);
>  }
>  
> -static void htcherald_panel_drv_cleanup(void)
> +static void __exit htcherald_panel_drv_cleanup(void)
>  {
>  	platform_driver_unregister(&htcherald_panel_driver);
>  }

Doesn't seem to be in linux-next as of today. Applied myself, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
