Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZESFf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZESFf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 01:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZESFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 01:35:18 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:42525 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750900AbZESFfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 01:35:17 -0400
Message-ID: <4A124514.2090609@snapgear.com>
Date: Tue, 19 May 2009 15:35:16 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] istallion: add missing __devexit marking
References: <1242632850-16268-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1242632850-16268-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Mike Frysinger wrote:
> The remove member of the pci_driver stli_pcidriver uses __devexit_p(),
> so the remove function itself should be marked with __devexit.  Even
> more so considering the probe function is marked with __devinit.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Greg Ungerer <gerg@uclinux.org>

Looks ok to me:

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>  drivers/char/istallion.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
> index fff19f7..e8392c2 100644
> --- a/drivers/char/istallion.c
> +++ b/drivers/char/istallion.c
> @@ -3785,7 +3785,7 @@ err:
>  	return retval;
>  }
>  
> -static void stli_pciremove(struct pci_dev *pdev)
> +static void __devexit stli_pciremove(struct pci_dev *pdev)
>  {
>  	struct stlibrd *brdp = pci_get_drvdata(pdev);
>  

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
