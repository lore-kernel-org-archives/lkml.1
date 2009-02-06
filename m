Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZBFOEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZBFOEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZBFODz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:03:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:37060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbZBFODy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:03:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="487861988"
Date: Fri, 6 Feb 2009 15:06:18 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mfd: PCF50633: remove duplicated #include
Message-ID: <20090206140617.GI3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20090115064950.1F10.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115064950.1F10.WEIYI.HUANG@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 06:53:29AM +0800, Huang Weiyi wrote:
> Removed duplicated #include <linux/device.h> in
>   drivers/mfd/pcf50633-core.c
Applied to my for-next branch, thanks.

Cheers,
Samuel.

 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> 
> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index 24508e2..feb8ddd 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -15,7 +15,6 @@
>  #include <linux/kernel.h>
>  #include <linux/device.h>
>  #include <linux/sysfs.h>
> -#include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/interrupt.h>
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
