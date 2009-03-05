Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZCELN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZCELN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZCELNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:13:51 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18280 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750868AbZCELNu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:13:50 -0500
X-BigFish: VPS-27(zz1432R98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KG15UG-04-12R-01
Date: Thu, 5 Mar 2009 12:13:28 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Hannes Eder <hannes@hanneseder.net>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IOMMU: use ANSI style function declaration for 'iommu_found'
Message-ID: <20090305111328.GA8751@amd.com>
References: <20090302000010.14884.9400.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090302000010.14884.9400.stgit@localhost.localdomain>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Mar 2009 11:13:28.0232 (UTC) FILETIME=[68DC6280:01C99D83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 01:00:41AM +0100, Hannes Eder wrote:
> Fix this sparse warning:
>   drivers/base/iommu.c:34:18: warning: non-ANSI function declaration of function 'iommu_found'
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/base/iommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
> index 5e039d4..c2d1eed 100644
> --- a/drivers/base/iommu.c
> +++ b/drivers/base/iommu.c
> @@ -31,7 +31,7 @@ void register_iommu(struct iommu_ops *ops)
>  	iommu_ops = ops;
>  }
>  
> -bool iommu_found()
> +bool iommu_found(void)
>  {
>  	return iommu_ops != NULL;
>  }

Applied, thanks.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

