Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZKESly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZKESly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbZKESlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:41:52 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53580 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501AbZKESlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=msPum2ZU5QPVdFjWygHnUX7jooINeEHsCPQtinHjTrlN3X77nAs0T9DXUNGkewl7TB
         vmRAACri4NWVMGn/VoG2HsMqi3F2Ka9SutXZlx2bdTnJpVHvGfkB9aUzbZjPQiXZRsKT
         CC1czXjpUlBGmx42tJdhG6jK+QTiKXZwXp8BA=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 06/41] rt2800pci: fix comment about IV/EIV fields
Date: Thu, 5 Nov 2009 19:41:53 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173239.28463.22571.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173239.28463.22571.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051941.53838.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: fix comment about IV/EIV fields
> 
> The bit tested by hardware is TXD_W3_WIV and its value
> equals the negated value of ENTRY_TXD_ENCRYPT_IV bit.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -2206,8 +2206,8 @@ static void rt2800pci_write_tx_desc(stru
>  
>  	/*
>  	 * Always write 0 to IV/EIV fields, hardware will insert the IV
> -	 * from the IVEIV register when ENTRY_TXD_ENCRYPT_IV is set to 0.
> -	 * When ENTRY_TXD_ENCRYPT_IV is set to 1 it will use the IV data
> +	 * from the IVEIV register when TXD_W3_WIV is set to 0.
> +	 * When TXD_W3_WIV is set to 1 it will use the IV data
>  	 * from the descriptor. The TXWI_W1_WIRELESS_CLI_ID indicates which
>  	 * crypto entry in the registers should be used to encrypt the frame.
>  	 */
> 


