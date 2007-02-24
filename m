Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXBXPma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXBXPma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbXBXPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:42:30 -0500
Received: from trinity.fluff.org ([217.147.94.151]:2357 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbXBXPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:42:29 -0500
Date: Sat, 24 Feb 2007 15:42:17 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vincent Sanders <vince@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/mfd/sm501.c: Replace pci_module_init with pci_register_driver
Message-ID: <20070224154217.GK14228@trinity.fluff.org>
References: <20070224104603.20765.30521.sendpatchset@thinktank.campus.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224104603.20765.30521.sendpatchset@thinktank.campus.ltu.se>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 11:46:06AM +0100, Richard Knutsson wrote:
> Replace pci_module_init with pci_register_driver

Thankyou for spotting this.
 
> Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
> Compile-tested with "allyes", "allmod" & "allno" on i386
> 
> diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
> index 5c5a1e2..c707c8e 100644
> --- a/drivers/mfd/sm501.c
> +++ b/drivers/mfd/sm501.c
> @@ -1131,7 +1131,7 @@ static struct platform_driver sm501_plat_drv = {
>  static int __init sm501_base_init(void)
>  {
>  	platform_driver_register(&sm501_plat_drv);
> -	return pci_module_init(&sm501_pci_drv);
> +	return pci_register_driver(&sm501_pci_drv);
>  }
>  
>  static void __exit sm501_base_exit(void)

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

