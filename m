Return-Path: <linux-kernel-owner+w=401wt.eu-S1030512AbXFHNLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030512AbXFHNLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030235AbXFHNJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:09:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48482 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968802AbXFHNJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ldYwu+Q6i4NKaHCIKtU0FsdGpcu+TsSabVOaKMjCkMV7cxZA9MSfMSeyfX+8hdPOUG87VvBV830NEgqFzZXDN1ZqW33BJX/jMC9WX2Q1KI3gK4SetkkKGgFhGtendStzBT9LqiaUpqAUJiN/foPoxcIKJ2/d6JMMa54T81BlDJc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Peer Chen" <peerchen@gmail.com>
Subject: Re: [PATCH 2/3] PATA: Add the MCP73/77 support to PATA driver
Date: Fri, 8 Jun 2007 15:05:57 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "alan" <alan@redhat.com>,
       "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>,
       "htejun" <htejun@gmail.com>
References: <200706071824343417345@gmail.com>
In-Reply-To: <200706071824343417345@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706081505.58068.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007, Peer Chen wrote:
> Add the MCP73/MCP77 support to PATA driver.
> The patch base on kernel 2.6.22-rc4
>  
> Signed-off-by: Peer Chen <peerchen@gmail.com>

Added amd74xx_chipets[] and amd_pci_tbl[] entries.
Bumped driver version.

applied

> ---------------------------------------------------
> --- linux-2.6.22-rc4/drivers/ide/pci/amd74xx.c.orig
> +++ linux-2.6.22-rc4/drivers/ide/pci/amd74xx.c
> @@ -76,6 +76,8 @@ static struct amd_ide_chip {
>  	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE,	0x50, AMD_UDMA_133 },
>  	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE,	0x50, AMD_UDMA_133 },
>  	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE,	0x50, AMD_UDMA_133 },
> +	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE,	0x50, AMD_UDMA_133 },
> +	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE,	0x50, AMD_UDMA_133 },
>  	{ PCI_DEVICE_ID_AMD_CS5536_IDE,			0x40, AMD_UDMA_100 },
>  	{ 0 }
>  };
