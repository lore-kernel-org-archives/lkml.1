Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbXGYCFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbXGYCFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 22:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbXGYCFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 22:05:10 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:17538 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115AbXGYCFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 22:05:08 -0400
Date: Tue, 24 Jul 2007 22:01:39 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH][07/37] Clean up duplicate includes in drivers/hwmon/
Message-ID: <20070725020139.GB3767@jupiter.solarsys.private>
References: <200707211702.01755.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707211702.01755.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper:

* Jesper Juhl <jesper.juhl@gmail.com> [2007-07-21 17:02:01 +0200]:
> Hi,
> 
> This patch cleans up duplicate includes in
> 	drivers/hwmon/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/drivers/hwmon/ams/ams-core.c b/drivers/hwmon/ams/ams-core.c
> index 6db9737..a112a03 100644
> --- a/drivers/hwmon/ams/ams-core.c
> +++ b/drivers/hwmon/ams/ams-core.c
> @@ -23,7 +23,6 @@
>  #include <linux/types.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
> -#include <linux/module.h>
>  #include <asm/pmac_pfunc.h>
>  #include <asm/of_platform.h>
>  

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

