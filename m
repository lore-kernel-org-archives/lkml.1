Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZFZC0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZFZC0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZFZC0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:26:32 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60358 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZFZC0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:26:31 -0400
Message-ID: <4A4431D9.10906@oss.ntt.co.jp>
Date: Fri, 26 Jun 2009 11:26:33 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: jbeulich@novell.com, gregkh@suse.de, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com
Subject: Re: [PATCH] PCI: remove pci_dac_dma_... APIs on mn10300
References: <1228367335.10823.22.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1228367335.10823.22.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao wrote:
> It seems that mn10300 made it upstream after Jan Beulich's pci_dac_dma_*
> cleanup work and still defines pci_dac_dma_supported(). This API is not
> required by the PCI subsystem anymore, so remove it.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.28-rc7-orig/include/asm-mn10300/pci.h linux-2.6.28-rc7/include/asm-mn10300/pci.h
> --- linux-2.6.28-rc7-orig/include/asm-mn10300/pci.h	2008-10-10 07:13:53.000000000 +0900
> +++ linux-2.6.28-rc7/include/asm-mn10300/pci.h	2008-12-04 13:53:13.000000000 +0900
> @@ -70,10 +70,6 @@ struct pci_dev;
>   */
>  #define PCI_DMA_BUS_IS_PHYS	(1)
>  
> -
> -/* This is always fine. */
> -#define pci_dac_dma_supported(pci_dev, mask)	(0)
> -
>  /* Return the index of the PCI controller for device. */
>  static inline int pci_controller_num(struct pci_dev *dev)
>  {

It seems this patch slipped through the cracks. I will be replying to this email
with an updated version rebased against 2.6.31-rc1.

Thanks,

Fernando
