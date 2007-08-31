Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXHaLG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXHaLG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXHaLGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:06:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35830 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbXHaLGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:06:15 -0400
Date: Fri, 31 Aug 2007 16:49:15 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ysato@users.sourceforge.jp, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] H8/300:  Fix misnamed "CONFIG_BLKDEV_RESERVE_ADDRESS"
 Kconfig variable.
In-Reply-To: <Pine.LNX.4.64.0708310452530.1209@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0708311647570.7173@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708310452530.1209@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Acked-by: Satyam Sharma <satyam@infradead.org>

This is a bugfix, true.


>   if i read correctly an email i just got from Yoshinori Sato, he
> wanted me to post this to the main list.  it seems an obvious enough
> error that it can probably be pushed to the main tree fairly soon,
> unless i've messed something up here.
> 
> 
> diff --git a/arch/h8300/Kconfig.debug b/arch/h8300/Kconfig.debug
> index 554efe6..996d97e 100644
> --- a/arch/h8300/Kconfig.debug
> +++ b/arch/h8300/Kconfig.debug
> @@ -59,7 +59,7 @@ config BLKDEV_RESERVE
>  	help
>  	  Reserved BLKDEV area.
> 
> -config CONFIG_BLKDEV_RESERVE_ADDRESS
> +config BLKDEV_RESERVE_ADDRESS
>  	hex 'start address'
>  	depends on BLKDEV_RESERVE
>  	help
