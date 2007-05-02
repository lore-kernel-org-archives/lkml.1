Return-Path: <linux-kernel-owner+w=401wt.eu-S1766902AbXEBUFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766902AbXEBUFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766922AbXEBUFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:05:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54037 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766902AbXEBUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:05:08 -0400
Date: Wed, 2 May 2007 21:05:06 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] VIDEO: Remove archaic if[] construct from Kconfig file.
In-Reply-To: <Pine.LNX.4.64.0705020920580.9346@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705022104270.6403@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0705020920580.9346@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Remove the obsolete "if [ ]" construct from the video console Kconfig
> file.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   not sure who should have been CCed on this one.
> 
> 
> diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
> index aa3935d..63b85bf 100644
> --- a/drivers/video/console/Kconfig
> +++ b/drivers/video/console/Kconfig
> @@ -19,13 +19,6 @@ config VGA_CONSOLE
> 
>  	  Say Y.
> 
> -#	if [ "$CONFIG_PCI" = "y" -a "$CONFIG_VGA_CONSOLE" = "y" ]; then
> -#	   bool '   Allow VGA on any bus?' CONFIG_VGA_HOSE
> -#	   if [ "$CONFIG_VGA_HOSE" = "y" ]; then
> -#	      define_bool CONFIG_DUMMY_CONSOLE y
> -#	   fi
> -#	fi
> -
>  config VGACON_SOFT_SCROLLBACK
>         bool "Enable Scrollback Buffer in System RAM"
>         depends on VGA_CONSOLE
> 

Acked-by: James Simmons <jsimmons@infradead.org>
