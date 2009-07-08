Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZGHRjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZGHRjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZGHRjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:39:47 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:47769 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754339AbZGHRjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:39:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uSW1OTqBJOIfD/jIO+6C7taTFe2KZ+bnQG6nXvbNIzJMKyMBOjoUvsE/CMrnpL+BCdTxnYIaKMsbySLD1a6RxrZOcxwpHclozVe6D1jycfgut0uSG3b8Uvot3O2lSX17DZF/SlJiXJzAORuNnPrXLP8FC2URYN0C6vdl1S0nlMw=  ;
X-YMail-OSG: txUpXZIVM1nLYYWJdgICWJNuVBjzjslybXCo6vuvKnuW2zbfLnPtJxjitD7nDs0_82lzqj7pkOJgaG0Vkpy52ZvYFydodsRNHP_Pm9SO9cQ1dRpFpKffgbu7iJC2LmYJvmNdxJQwCNlqTzsvD8dTuJ3k5WFlDa.BF8IYbYXvrHoYhQgw._RHxdPkuP3AMbUMBa21iJY_GBXKz_ETcQU6BigMm65Yu6bUnSuzhLnvnNpVadXiwMCHsBaEuV45wd0bHgXS8ec5hpEV65zA2j6bvwCViGUL48EjjJY.JgBcac1vvVD4ZJDuq3Folg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH 29/44] includecheck fix: drivers/spi, amba-pl022.c
Date: Wed, 8 Jul 2009 10:39:44 -0700
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1247063308.4382.12.camel@ht.satnam> <1247067147.4382.80.camel@ht.satnam>
In-Reply-To: <1247067147.4382.80.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081039.44665.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Jaswinder Singh Rajput wrote:
> 
> fix the following 'make includecheck' warnings:
> 
>   drivers/spi/amba-pl022.c: linux/delay.h is included more than once.
>   drivers/spi/amba-pl022.c: linux/errno.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/spi/amba-pl022.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
> index da76797..c0f950a 100644
> --- a/drivers/spi/amba-pl022.c
> +++ b/drivers/spi/amba-pl022.c
> @@ -38,14 +38,12 @@
>  #include <linux/interrupt.h>
>  #include <linux/spi/spi.h>
>  #include <linux/workqueue.h>
> -#include <linux/errno.h>
>  #include <linux/delay.h>
>  #include <linux/clk.h>
>  #include <linux/err.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/pl022.h>
>  #include <linux/io.h>
> -#include <linux/delay.h>
>  
>  /*
>   * This macro is used to define some register default values.
> -- 
> 1.6.0.6
> 
> 
> 
> 


