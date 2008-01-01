Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYAAAwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYAAAwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 19:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYAAAwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 19:52:25 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:59964 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYAAAwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 19:52:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Subject: Re: [PATCH 1/2] ssb: add 'ssb_pcihost_set_power_state' function
Date: Tue, 1 Jan 2008 01:50:47 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linville@tuxdriver.com
References: <200801010116.46190.mboton@gmail.com>
In-Reply-To: <200801010116.46190.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801010150.47787.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 January 2008 01:16:46 Miguel Botón wrote:
> This patch adds the 'ssb_pcihost_set_power_state' function.
> 
> This function allows us to set the power state of a PCI device
> (for example b44 ethernet device). 
> 
> Signed-off-by: Miguel Botón <mboton@gmail.com>

Acked-by: Michael Buesch <mb@bu3sch.de>

> 
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index a21ab29..aa70fd0 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -349,6 +349,13 @@ static inline void ssb_pcihost_unregister(struct pci_driver *driver)
>  {
>  	pci_unregister_driver(driver);
>  }
> +
> +static inline
> +void ssb_pcihost_set_power_state(struct ssb_device *sdev, pci_power_t state)
> +{
> +	if (sdev->bus->bustype == SSB_BUSTYPE_PCI)
> +		pci_set_power_state(sdev->bus->host_pci, state);
> +}
>  #endif /* CONFIG_SSB_PCIHOST */
>  
>  
> 



-- 
Greetings Michael.
