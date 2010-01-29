Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243Ab0A2TbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0A2TbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 14:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742Ab0A2TbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 14:31:25 -0500
Received: from exht1.emulex.com ([138.239.113.183]:53980 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753541Ab0A2TbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 14:31:24 -0500
Message-ID: <4B633776.6060404@emulex.com>
Date: Fri, 29 Jan 2010 14:31:02 -0500
From: James Smart <james.smart@emulex.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lpfc: Positive error return into negative
References: <4B62B3C6.5090903@gmail.com>
In-Reply-To: <4B62B3C6.5090903@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is innoculous as the code really only cares whether it's zero or 
non-zero. But, there's no harm in being consistent.

Acked-by: James Smart <james.smart@emulex.com>

-- james s


Roel Kluin wrote:
> In the comment on top of lpfc_sli_hbq_setup() and of its caller which
> transmits this error, lpfc_sli_hba_setup(), it is stated that the
> function should return a negative error code.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 589549b..a960736 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -3709,7 +3709,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba)
>  
>  			phba->link_state = LPFC_HBA_ERROR;
>  			mempool_free(pmb, phba->mbox_mem_pool);
> -			return ENXIO;
> +			return -ENXIO;
>  		}
>  	}
>  	phba->hbq_count = hbq_count;
>
>   
