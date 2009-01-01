Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZAAEkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZAAEkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 23:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZAAEkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 23:40:04 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:37857 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbZAAEkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 23:40:02 -0500
Message-ID: <495C4916.3080700@oracle.com>
Date: Wed, 31 Dec 2008 20:39:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jianjun Kong <jianjun@zeuux.org>
CC: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       mporter@kernel.crashing.org
Subject: Re: [PATCH] rapidio: fix kernel-doc warning
References: <20090101043749.GA14614@ubuntu>
In-Reply-To: <20090101043749.GA14614@ubuntu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.495C4919.02F6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianjun Kong wrote:
> rapidio: fix kernel-doc warning
> 
> Fix kernel-doc parameter warning and correct the descriptio:
> Warning(/media/sda1/Project/linux-2.6//drivers/rapidio/rio-driver.c:88): Excess function parameter 'id'
> description in 'rio_device_probe'
> The parameter 'id' may be deleted.
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> Cc: Matt Porter <mporter@kernel.crashing.org>

Hi and thanks, but this is already fixed in Andrew Morton's mm patch series.
You should probably check there for other such patches.


> ---
>  drivers/rapidio/rio-driver.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
> index 956d3e7..cd6f14e 100644
> --- a/drivers/rapidio/rio-driver.c
> +++ b/drivers/rapidio/rio-driver.c
> @@ -78,8 +78,7 @@ void rio_dev_put(struct rio_dev *rdev)
>  }
>  
>  /**
> - *  rio_device_probe - Tell if a RIO device structure has a matching RIO device id structure
> - *  @id: the RIO device id structure to match against
> + *  rio_device_probe - Tell if a RIO device structure has a matching RIO device structure
>   *  @dev: the RIO device structure to match against
>   *
>   * return 0 and set rio_dev->driver when drv claims rio_dev, else error


-- 
~Randy
