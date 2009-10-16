Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbZJPK2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbZJPK2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZJPK2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:28:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44589 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680AbZJPK2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:28:01 -0400
Message-ID: <4AD84A8B.7060100@garzik.org>
Date: Fri, 16 Oct 2009 06:27:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: JosephChan@via.com.tw
CC: linux-kernel@vger.kernel.org, stable@kernel.org, alan@lxorguk.ukuu.org.uk,
       tj@kernel.org
Subject: Re: [patch 1/1 v2] pata_via.c : extend the rev_max for VT6330
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB80A1D1E6E@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB80A1D1E6E@exchtp03.taipei.via.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2009 03:45 AM, JosephChan@via.com.tw wrote:
> Fix the VT6330 issue, it's because the rev_max of VT6330 exceeds 0x2f.
> The VT6415 and VT6330 share the same device ID.
>
> Signed-off-by: Joseph Chan<josephchan@via.com.tw>
>
> --- a/drivers/ata/pata_via.c	2009-10-15 23:12:49.000000000 +0800
> +++ b/drivers/ata/pata_via.c	2009-10-15 23:12:57.000000000 +0800
> @@ -111,7 +111,7 @@
>   	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
>   	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
>   	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
> -	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
> +	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
>   	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
>   	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
>   	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },

applied

