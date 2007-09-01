Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXIAKcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXIAKcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXIAKcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:32:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53457 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbXIAKcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:32:32 -0400
Message-ID: <46D93FBB.10601@garzik.org>
Date: Sat, 01 Sep 2007 06:32:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Grant Wilson <grant.wilson@zen.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc5 - oops
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org> <20070901101110.038835c2@worthy.swandive.local> <20070901102050.GA7425@cvg>
In-Reply-To: <20070901102050.GA7425@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> test this, does it help?
> 
> 		Cyrill
> ---
> 
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index e40c94f..8031697 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -1187,6 +1187,7 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
>  				DMI_MATCH(DMI_PRODUCT_NAME, "M570U"),
>  			},
>  		},
> +		{}
>  	};


heh, you beat me to it.  That should indeed fix it.

	Jeff


