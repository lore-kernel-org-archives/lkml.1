Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZA3Tq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZA3Tq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZA3TqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:46:20 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:48924 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752514AbZA3TqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:46:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xXOUeff3Rx5YoNkXkQlZbL9Gc9LdK4wmHaSNHZdWRSj5FiyQzpJkCKfYaKuimxx0O5Jvk47XJKubvUtQI22ZuQYy4nUPtsNwidqa+n4dGYBp+Iv985ZUptaChQf4Ixa7qml2XLL9MrAhFuOib8l9umC2R/jxp5gQVi+7IdxBo5U=  ;
X-YMail-OSG: .8jvY3QVM1kG13ciRawnCLoWFSxgj.lBm.ucoZv20V53nXxhcy3G2FQitJeFiqLtErVVbrj90UKFz87K8rkL4y_hblh7j4CKqdyXDfthB4cIL4XEGtpWnfzIpdp0Y1MHxsOVUgNS3vsBEzsFaC22IQ5Trl0AAW1tdAafDyaajVRgkN_VyNnYmAvQGLdw9AtUY5sG7jonnDy38awOaTmsg_C2RmdG4q5EJ.Q-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [PATCH] mfd: Fix TWL4030 build on some ARM variants
Date: Fri, 30 Jan 2009 11:46:15 -0800
User-Agent: KMail/1.9.10
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
References: <1233340937-7679-1-git-send-email-broonie@sirena.org.uk>
In-Reply-To: <1233340937-7679-1-git-send-email-broonie@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301146.16242.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009, Mark Brown wrote:
> Many ARM platforms do not provide a mach/cpu.h so rather than guarding
> the use of that header with CONFIG_ARM guard it with the guards used
> when testing for the OMAP variants in the body of the code.
> 
> Signed-off-by: Mark Brown <broonie@sirena.org.uk>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/mfd/twl4030-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index e7ab003..68826f1 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -38,7 +38,7 @@
>  #include <linux/i2c.h>
>  #include <linux/i2c/twl4030.h>
>  
> -#ifdef CONFIG_ARM
> +#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
>  #include <mach/cpu.h>
>  #endif
>  
> -- 
> 1.5.6.3
> 
> 


