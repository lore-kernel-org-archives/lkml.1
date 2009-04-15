Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZDOJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZDOJ6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZDOJ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:58:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZDOJ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:58:12 -0400
Date: Wed, 15 Apr 2009 11:58:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: linux-mtd@lists.infradead.org, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: fix Kconfig comment about 'armflash'
In-Reply-To: <20090406131054.16163.11343.stgit@Programuotojas>
Message-ID: <alpine.LNX.2.00.0904151158020.13028@wotan.suse.de>
References: <20090406131054.16163.11343.stgit@Programuotojas>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Paulius Zaleckas wrote:

> The real 'armflash' map driver is selected by CONFIG_MTD_ARM_INTEGRATOR
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> ---
> 
>  drivers/mtd/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index 7d04fb9..b8e35a0 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -154,7 +154,8 @@ config MTD_AFS_PARTS
>  
>  	  You will still need the parsing functions to be called by the driver
>  	  for your particular device. It won't happen automatically. The
> -	  'armflash' map driver (CONFIG_MTD_ARMFLASH) does this, for example.
> +	  'armflash' map driver (CONFIG_MTD_ARM_INTEGRATOR) does this, for
> +	  example.
>  
>  config MTD_OF_PARTS
>  	tristate "Flash partition map based on OF description"

Applied to trivial tree, thanks.

-- 
Jiri Kosina
SUSE Labs
