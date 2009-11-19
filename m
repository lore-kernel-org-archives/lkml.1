Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZKSVsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZKSVsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZKSVs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:48:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34943 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZKSVs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:48:29 -0500
Message-ID: <4B05BD2A.5070706@pobox.com>
Date: Thu, 19 Nov 2009 16:48:26 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911191645.29885.bzolnier@gmail.com> <20091119162738.7e8e5665@lxorguk.ukuu.org.uk> <200911191838.11791.bzolnier@gmail.com>
In-Reply-To: <200911191838.11791.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 12:38 PM, Bartlomiej Zolnierkiewicz wrote:
>
> Index: b/drivers/ata/pata_hpt3x2n.c
> ===================================================================
> --- a/drivers/ata/pata_hpt3x2n.c
> +++ b/drivers/ata/pata_hpt3x2n.c
> @@ -133,7 +133,7 @@ static int hpt3x2n_cable_detect(struct a
>   	/* Restore state */
>   	pci_write_config_byte(pdev, 0x5B, scr2);
>
> -	if (ata66&  (1<<  ap->port_no))
> +	if (ata66&  (2>>  ap->port_no))
>   		return ATA_CBL_PATA40;
>   	else
>   		return ATA_CBL_PATA80;


Applied.

Note to Alan -- even if cable detect wants more changes, this is a nice, 
self-contained fix easily backported to stable@, etc.  So I preferred 
the above form of change.

Please do send any updates you guys (Bart | Alan) have on top of 
libata-dev.git#upstream.

Thanks,

	Jeff



