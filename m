Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbZKESlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbZKESlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbZKESlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:41:44 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53580 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380AbZKESlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:41:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LU34f6eyUwqDUKi5DZLuX7nvmfFXKZg9uCC1H/JLpa6dsGAI0SOqQtEfUBv2gvnbY2
         /ofWZ+HJmzvOyqYUVtoElSpAgijlwTpBpAzihbpKZ9ycd8NIynJq9hoW+4lsVTQ6WEQv
         vek1uPbBMWxzpPXQNJ3kUhpwp604s3KVB/29I=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 05/41] rt2800pci: fix comment about register access
Date: Thu, 5 Nov 2009 19:41:43 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173232.28463.47998.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173232.28463.47998.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051941.44268.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: fix comment about register access
> 
> Registers used for indirect BBP and RF registers access are
> respectively BBPCSR and RFCSR, also make it clear that all CSR
> registers access goes through rt2x00pci_register_[read,write]()
> methods.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -56,8 +56,10 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
>  
>  /*
>   * Register access.
> + * All access to the CSR registers will go through the methods
> + * rt2x00pci_register_read and rt2x00pci_register_write.
>   * BBP and RF register require indirect register access,
> - * and use the CSR registers PHY_CSR3 and PHY_CSR4 to achieve this.
> + * and use the CSR registers BBPCSR and RFCSR to achieve this.
>   * These indirect registers work with busy bits,
>   * and we will try maximal REGISTER_BUSY_COUNT times to access
>   * the register while taking a REGISTER_BUSY_DELAY us delay
> 


