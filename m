Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYDYEtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYDYEtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbYDYEsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:48:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46597 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757930AbYDYEso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:48:44 -0400
Message-ID: <481162A4.50500@garzik.org>
Date: Fri, 25 Apr 2008 00:48:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make sata_set_spd_needed() static
References: <20080421085117.GC26897@cs181133002.pp.htv.fi>
In-Reply-To: <20080421085117.GC26897@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> sata_set_spd_needed() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/ata/libata-core.c |    2 +-
>  drivers/ata/libata.h      |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> bb4bcf58edb56a5fc9d7401046adcafcffff46a6 diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 4b918d7..8c2bb65 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2761,7 +2761,7 @@ static int __sata_set_spd_needed(struct ata_link *link, u32 *scontrol)
>   *	RETURNS:
>   *	1 if SATA spd configuration is needed, 0 otherwise.
>   */
> -int sata_set_spd_needed(struct ata_link *link)
> +static int sata_set_spd_needed(struct ata_link *link)
>  {
>  	u32 scontrol;
>  
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 4aeeabb..ae2cfd9 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -101,7 +101,6 @@ extern int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
>  			      unsigned int readid_flags);
>  extern int ata_dev_configure(struct ata_device *dev);
>  extern int sata_down_spd_limit(struct ata_link *link);
> -extern int sata_set_spd_needed(struct ata_link *link);
>  extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
>  extern void ata_sg_clean(struct ata_queued_cmd *qc);
>  extern void ata_qc_free(struct ata_queued_cmd *qc);

applied


