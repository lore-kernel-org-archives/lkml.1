Return-Path: <linux-kernel-owner+w=401wt.eu-S1763476AbXJRNt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476AbXJRNt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXJRNtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:49:50 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:10324 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXJRNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:49:49 -0400
Date: Thu, 18 Oct 2007 09:34:52 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] hwmon/ibmpex.c: fix NULL dereference
Message-ID: <20071018133452.GB3526@jupiter.solarsys.private>
References: <20071017192902.GB3778@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017192902.GB3778@stusta.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Adrian Bunk <bunk@kernel.org> [2007-10-17 21:29:02 +0200]:
> Don't dereference "data" when we know for sure it's NULL.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 66bec2ef5c6d55fc30ef6ac5bb97fdfcfaf394f2 
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> index c462824..e14ce3d 100644
> --- a/drivers/hwmon/ibmpex.c
> +++ b/drivers/hwmon/ibmpex.c
> @@ -457,7 +457,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data) {
>  		printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
> -		       "interface %d.\n", data->interface);
> +		       "interface.\n");
>  		return;
>  	}
>  

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

