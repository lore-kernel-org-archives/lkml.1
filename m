Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbXJXQ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbXJXQ6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbXJXQnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:43:49 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47017 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764070AbXJXQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:43:47 -0400
Date: Wed, 24 Oct 2007 12:43:47 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] some overdue I2C driver removal
Message-ID: <20071024164347.GN4003@csclub.uwaterloo.ca>
References: <20071024162528.GX30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162528.GX30533@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 06:25:28PM +0200, Adrian Bunk wrote:
> This patch contains the overdue removal of three I2C drivers.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  Documentation/feature-removal-schedule.txt |    8 
>  drivers/i2c/busses/Kconfig                 |   59 ------
>  drivers/i2c/busses/Makefile                |    3 
>  drivers/i2c/busses/i2c-ixp2000.c           |  167 -------------------
>  drivers/i2c/busses/i2c-ixp4xx.c            |  178 ---------------------
>  drivers/i2c/busses/scx200_i2c.c            |  131 ---------------
>  6 files changed, 546 deletions(-)
> 
> 6a8e0e37019c0ffeb0071fae30210baf2c3bdd75 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 2af3835..9114379 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -218,14 +218,6 @@ Who:	Len Brown <len.brown@intel.com>
>  
>  ---------------------------
>  
> -What:	i2c-ixp2000, i2c-ixp4xx and scx200_i2c drivers
> -When:	September 2007
> -Why:	Obsolete. The new i2c-gpio driver replaces all hardware-specific
> -	I2C-over-GPIO drivers.
> -Who:	Jean Delvare <khali@linux-fr.org>
> -
> ----------------------------

Did anyone ever write a driver that does i2c on the scx200 using the new
i2c-gpio method?  I sure haven't seen it, although I am still running
2.6.18 (since that is what debian stable uses) on my scx200 systems.  I
certainly haven't found any useful instructions on how to use the new
i2c-gpio driver on an scx200.

--
Len Sorensen
