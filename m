Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672Ab0AMOzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0AMOzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688Ab0AMOzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:55:15 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:17211 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab0AMOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:55:14 -0500
Date: Wed, 13 Jan 2010 08:57:38 -0600
From: scameron@beardog.cce.hp.com
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux SCSI <linux-scsi@vger.kernel.org>
Subject: Re: your mail
Message-ID: <20100113145738.GQ13413@beardog.cce.hp.com>
References: <20100113004939.289333186@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113004939.289333186@suse.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 07:49:00PM -0500, Jeff Mahoney wrote:
> Subject: [patch 5/6] hpsa: Fix section mismatch
> References: <20100113004855.550486769@suse.com>
> Content-Disposition: inline; filename=patches.rpmify/hpsa-fix-section-mismatch
> 
>  hpsa_pci_init calls hpsa_interrupt_mode which is a __devinit function.
>  hpsa_pci_init is only called by hpsa_init_one which is also __devinit, so
>  mark it __devinit as well.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  drivers/scsi/hpsa.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3111,7 +3111,7 @@ default_int_mode:
>  	return;
>  }
>  
> -static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
> +static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
>  {
>  	ushort subsystem_vendor_id, subsystem_device_id, command;
>  	__u32 board_id, scratchpad = 0;
> 

Thanks.

-- steve

