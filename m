Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbYAaKbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbYAaKbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762067AbYAaKbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:31:43 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:36352 "EHLO
	outbound5-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbYAaKbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:31:41 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JVI7R2-01-781-01
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Message-ID: <47A1A335.9090400@amd.com>
Date: Thu, 31 Jan 2008 11:30:13 +0100
From: "Thomas Dahlmann" <thomas.dahlmann@amd.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: "Roel Kluin" <12o3l@tiscali.nl>
cc: info-linux@geode.amd.com, "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][drivers/usb/gadget/amd5536udc.c] duplicate
 use_dma_ppb_du => 2nd use_dma_ppb
References: <47A08FD5.20105@tiscali.nl>
In-Reply-To: <47A08FD5.20105@tiscali.nl>
X-OriginalArrivalTime: 31 Jan 2008 10:27:13.0201 (UTC)
 FILETIME=[D7FE0210:01C863F3]
X-WSS-ID: 6BBF7D3107S9492661-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix is correct.

Thanks,
Thomas

Roel Kluin wrote:
> Untested patch below, please confirm it's the right fix.
> --
> duplicate use_dma_ppb_du, 2nd should be use_dma_ppb
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> index c72e962..fbc10f9 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -205,7 +205,7 @@ static void print_regs(struct udc *dev)
>  		DBG(dev, "DMA mode       = PPBNDU (packet per buffer "
>  			"WITHOUT desc. update)\n");
>  		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBNDU");
> -	} else if (use_dma && use_dma_ppb_du && use_dma_ppb_du) {
> +	} else if (use_dma && use_dma_ppb && use_dma_ppb_du) {
>  		DBG(dev, "DMA mode       = PPBDU (packet per buffer "
>  			"WITH desc. update)\n");
>  		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBDU");
>
>
>   



