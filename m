Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXCGXzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXCGXzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXCGXzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:55:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39554 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXCGXzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:55:51 -0500
Date: Wed, 7 Mar 2007 15:55:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix erroneous "MODVERSIONS" with "CONFIG_MODVERSIONS".
Message-Id: <20070307155548.e00f95cc.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703071826490.3752@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703071826490.3752@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 18:28:48 -0500 (EST)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
>   Replace the apparently misspelled "MODVERSIONS" preprocessor
> variable with "CONFIG_MODVERSIONS".
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
> diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
> index 76357c8..94473fc 100644
> --- a/drivers/char/rocket.c
> +++ b/drivers/char/rocket.c
> @@ -65,7 +65,7 @@
> 
>  /****** Kernel includes ******/
> 
> -#ifdef MODVERSIONS
> +#ifdef CONFIG_MODVERSIONS
>  #include <config/modversions.h>
>  #endif
> 

It was obviously all do-nothing code, so I deleted it.
