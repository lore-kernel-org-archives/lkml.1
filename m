Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYHLWA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYHLWA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYHLWAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:00:46 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44927 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751303AbYHLWAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:00:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=GbneNH0KnIqD4S43FFcf7Tp/0RbfB0cMHuPKL5zR67Fd0xO3Bdy3Z9Qw0Aci89y14dBBTxKwXK4lmA/QY20yY9UZVR/e0vNbStwDrKUfsHVco7MzDO33VAjOGER6183MMKHEzG6c6kzh1nPPFlYptwHeGEH6QMb9obKf5SduFtU=  ;
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Aug 2008 15:06:19 -0700
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org, dbaryshkov@gmail.com
Subject: Re: [PATCH] Make gpiochip label const
Cc: dbrownell@users.sourceforge.net
References: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com>
In-Reply-To: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080812220619.D2011362B0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From dbaryshkov@gmail.com  Tue Aug 12 13:54:29 2008
> From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> To: linux-kernel@vger.kernel.org
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
> 	David Brownell <dbrownell@users.sourceforge.net>
> Subject: [PATCH] Make gpiochip label const
> Date: Wed, 13 Aug 2008 00:39:48 +0400
>
> Mark gpiochip label as a const char pointer.
>
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Acked-By: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  include/asm-generic/gpio.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 6be061d..8ab874a 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -58,7 +58,7 @@ struct module;
>   * is calculated by subtracting @base from the gpio number.
>   */
>  struct gpio_chip {
> -	char			*label;
> +	const char		*label;
>  	struct module		*owner;
>  
>  	int			(*direction_input)(struct gpio_chip *chip,
> -- 
> 1.5.6.3
>
