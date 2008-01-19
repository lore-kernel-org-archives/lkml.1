Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbYASN24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbYASN24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYASN2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:28:47 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42512 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbYASN2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:28:46 -0500
Date: Sat, 19 Jan 2008 14:28:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: chas@cmf.nrl.navy.mil, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] atm/idt77105.c: fix section mismatch
Message-ID: <20080119132852.GB26615@uranus.ravnborg.org>
References: <20080119131849.GA8669@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119131849.GA8669@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 03:18:49PM +0200, Adrian Bunk wrote:
> EXPORT_SYMBOL'ed code mustn't be __*init.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> ---
> --- linux-2.6/drivers/atm/idt77105.c.old	2008-01-19 11:19:53.000000000 +0200
> +++ linux-2.6/drivers/atm/idt77105.c	2008-01-19 11:20:10.000000000 +0200
> @@ -354,13 +354,13 @@ static const struct atmphy_ops idt77105_
>  	.ioctl =	idt77105_ioctl,
>  	.interrupt =	idt77105_int,
>  	.stop =		idt77105_stop,
>  };
>  
>  
> -int __devinit idt77105_init(struct atm_dev *dev)
> +int idt77105_init(struct atm_dev *dev)
>  {
>  	dev->phy = &idt77105_ops;
>  	return 0;
>  }
>  
>  EXPORT_SYMBOL(idt77105_init);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
