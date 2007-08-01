Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbXHANzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbXHANzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbXHANzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:55:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:30364 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760823AbXHANzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AsyS/w2QM7sk9OfHbdbkD5jm29gkLcDqSun5IDTny0/2sZJpP6+P7VbcOwplvs1RL+nENCKOmVdWNEWExMhZmmV0LKfavxIyRLp9K8NlNBV0ZHK20xoRi/q9ZrswBkSeIaoWKUIP5wvdmurJ193WPTzgJM+oqOKmvs+gnx/7kKI=
Message-ID: <46B090AD.2070305@googlemail.com>
Date: Wed, 01 Aug 2007 15:54:53 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Eugene Teo <eugeneteo@kernel.sg>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile
 error
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com> <20070801133912.GA11027@kernel.sg>
In-Reply-To: <20070801133912.GA11027@kernel.sg>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Teo wrote:
> Hi Gabriel,

Hi Eugene,
 
> Hope the following trivial patch helps.

Yes it does , thx.

> 
> <quote sender="Gabriel C">
>> Getting this with a randconfig ( http://194.231.229.228/MM/randconfig-auto-10 )
>>
> [...]
>> drivers/scsi/advansys.c:794:2: warning: #warning this driver is still not properly converted to the DMA API
>> drivers/scsi/advansys.c: In function 'advansys_board_found':
>> drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'
> [...]
> 
> This patch fixes the following compile error:
> 
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:17781: error: implicit declaration of function
> 'to_pci_dev'
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> ---
>  drivers/scsi/advansys.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 79c0b6e..908f02b 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -774,6 +774,7 @@
>  #include <linux/stat.h>
>  #include <linux/spinlock.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/pci.h>
>  
>  #include <asm/io.h>
>  #include <asm/system.h>
> 
> 
