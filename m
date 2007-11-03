Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXKCMsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXKCMsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbXKCMs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:48:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35155 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbXKCMsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:48:25 -0400
Message-ID: <472C6E14.5050101@garzik.org>
Date: Sat, 03 Nov 2007 08:48:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make ata_scsi_lpm_get() static
References: <20071030235023.GT7227@stusta.de>
In-Reply-To: <20071030235023.GT7227@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> ata_scsi_lpm_get() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 380046f657271be470566bb5c762c1599569bac6 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 93bd36c..c4f0c6c 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -120,7 +120,7 @@ static const struct {
>  	{ MEDIUM_POWER, "medium_power" },
>  };
>  
> -const char *ata_scsi_lpm_get(enum link_pm policy)
> +static const char *ata_scsi_lpm_get(enum link_pm policy)
>  {
>  	int i;
>  

applied


