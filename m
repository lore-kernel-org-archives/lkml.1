Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbYDNRxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbYDNRxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763303AbYDNRxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:53:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42481 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762988AbYDNRxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:53:15 -0400
Date: Mon, 14 Apr 2008 19:53:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Message-ID: <20080414175344.GA15028@uranus.ravnborg.org>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414141659.GF6695@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 05:16:59PM +0300, Adrian Bunk wrote:
> It's plain wrong for PCMCIA to select HAVE_IDE that implies e.g. the 
> availability of an asm/ide.h
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 9cdb66112488bc0c6e1d528444d3ba30d5b0487f diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> index 8b22281..519b4ff 100644
> --- a/drivers/pcmcia/Kconfig
> +++ b/drivers/pcmcia/Kconfig
> @@ -38,7 +38,6 @@ config PCMCIA_DEBUG
>  config PCMCIA
>  	tristate "16-bit PCMCIA support"
>  	select CRC32
> -	select HAVE_IDE
>  	default y

I did this when introducing HAVE_IDE.
But I do not recall why and the rationale for removing it
seems fine to me.

So patch looks good - but I have not investigated in detail.

	Sam
