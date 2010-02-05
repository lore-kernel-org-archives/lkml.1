Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab0BEN5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:57:08 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:62574 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932621Ab0BEN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:57:06 -0500
From: Frans Pop <elendil@planet.nl>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Subject: Re: [PATCH] non-existant config in kernel source (CONFIG_AHCI)
Date: Fri, 5 Feb 2010 14:57:00 +0100
User-Agent: KMail/1.9.9
Cc: jgarzik@pobox.com, knan-lkml@anduin.net, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de, alan@lxorguk.ukuu.org.uk
References: <20100205132959.GB6874@faui49.informatik.uni-erlangen.de>
In-reply-To: <20100205132959.GB6874@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002051457.04135.elendil@planet.nl>
X-OriginalArrivalTime: 05 Feb 2010 13:57:04.0168 (UTC) FILETIME=[18D31A80:01CAA66B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Egger wrote:
> --- a/drivers/ata/pata_marvell.c
> +++ b/drivers/ata/pata_marvell.c
> @@ -147,7 +147,7 @@ static int marvell_init_one (struct pci_dev *pdev,
> 	if (pdev->device == 0x6101)
>		ppi[1] = &ata_dummy_port_info;
> 
> -#if defined(CONFIG_AHCI) || defined(CONFIG_AHCI_MODULE)
> +#if defined(CONFIG_SATA_AHCI) || defined(SATA_CONFIG_AHCI_MODULE)

Shouldn't the last be CONFIG_SATA_AHCI_MODULE ?

Cheers,
FJP
