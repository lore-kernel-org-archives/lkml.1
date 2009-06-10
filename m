Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZFJCeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZFJCeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 22:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZFJCeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 22:34:18 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:36967 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbZFJCeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 22:34:17 -0400
Message-ID: <4A2F1BAA.4070102@snapgear.com>
Date: Wed, 10 Jun 2009 12:34:18 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       linux-mtd@lists.infradead.org
Subject: Re: [uClinux-dev] [PATCH 3/3] mtd/maps: uclinux: do not allow to
 be	built as a module
References: <20090526231902.GA6295@linux-sh.org> <1243380798-10089-3-git-send-email-vapier@gentoo.org>
In-Reply-To: <1243380798-10089-3-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mike Frysinger wrote:
> There isn't any benefit to building the uClinux MTD map as a module as the
> rootfs it requires in order to actually be usable is appended to the
> kernel image, not the module.  No known system builds it this way either,
> so change the option to "bool".
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Paul Mundt <lethal@linux-sh.org>
> CC: Greg Ungerer <gerg@uclinux.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> CC: uclinux-dev@uclinux.org
> CC: linux-mtd@lists.infradead.org
> ---
>  drivers/mtd/maps/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> index 82923bd..907873b 100644
> --- a/drivers/mtd/maps/Kconfig
> +++ b/drivers/mtd/maps/Kconfig
> @@ -501,7 +501,7 @@ config MTD_BFIN_ASYNC
>  	  If compiled as a module, it will be called bfin-async-flash.
>  
>  config MTD_UCLINUX
> -	tristate "Generic uClinux RAM/ROM filesystem support"
> +	bool "Generic uClinux RAM/ROM filesystem support"
>  	depends on MTD_PARTITIONS && MTD_RAM && !MMU
>  	help
>  	  Map driver to support image based filesystems for uClinux.

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
