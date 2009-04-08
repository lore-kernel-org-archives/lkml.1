Return-Path: <linux-kernel-owner+w=401wt.eu-S1762561AbZDHMar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762561AbZDHMar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZDHMag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:30:36 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:63325 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZDHMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y1oDFK6+VqZk+Nbe5OkwwlsfwHF+f02RRQgraOKFJmTLsplWSUuCFi4FrZmDvbb0w9
         3Hv3v6Znv4+b3st6zov8Z9pVdSdPTGRXnvm8osJF0K9HiXfEDT2Xbn4Ao7p08UzzAqoO
         dvK7YsZ+/iEfV47sbNedSXOMpbQ/uaCyDCM0c=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:30:31 +0200
Message-ID: <36ca99e90904080530w58a8e47fw351b900cb11cf17e@mail.gmail.com>
Subject: Re: [PATCH 30/56] net: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38CUrqu029935

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:> Remove uneeded void casts>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>> --->  drivers/net/arm/at91_ether.c           |    2 +->  drivers/net/cassini.c                  |    3 +-->  drivers/net/fs_enet/mac-fcc.c          |    2 +->  drivers/net/fs_enet/mac-fec.c          |    2 +->  drivers/net/fs_enet/mac-scc.c          |    3 +-->  drivers/net/gianfar.c                  |    2 +->  drivers/net/ibmveth.c                  |    4 ++-->  drivers/net/irda/au1k_ir.c             |    3 +-->  drivers/net/netxen/netxen_nic_init.c   |    6 ++---->  drivers/net/skfp/ess.c                 |   20 ++++++++++---------->  drivers/net/skfp/hwmtm.c               |    7 +++---->  drivers/net/skfp/pmf.c                 |    4 ++-->  drivers/net/skfp/smt.c                 |    3 +-->  drivers/net/sungem.c                   |    3 +-->  drivers/net/sunhme.c                   |    3 +-->  drivers/net/typhoon.c                  |    2 +->  drivers/net/via-velocity.c             |    2 +->  drivers/net/wan/dscc4.c                |    6 +++--->  drivers/net/wireless/ipw2x00/ipw2100.c |    3 +-->  19 files changed, 35 insertions(+), 45 deletions(-)>> diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c> index 5c6315d..d3c58fe 100644> --- a/drivers/net/ibmveth.c> +++ b/drivers/net/ibmveth.c> @@ -1218,7 +1218,7 @@ static int __devinit ibmveth_probe(struct vio_dev *dev, const struct vio_device_>        ibmveth_debug_printk_no_adapter("entering ibmveth_probe for UA 0x%x\n",>                                        dev->unit_address);>> -       mac_addr_p = (unsigned char *) vio_get_attribute(dev,> +       mac_addr_p = vio_get_attribute(dev,>                                                VETH_MAC_ADDR, NULL);Please check.
>        if(!mac_addr_p) {>                printk(KERN_ERR "(%s:%3.3d) ERROR: Can't find VETH_MAC_ADDR "> @@ -1226,7 +1226,7 @@ static int __devinit ibmveth_probe(struct vio_dev *dev, const struct vio_device_>                return 0;>        }>> -       mcastFilterSize_p = (unsigned int *) vio_get_attribute(dev,> +       mcastFilterSize_p = vio_get_attribute(dev,>                                                VETH_MCAST_FILTER_SIZE, NULL);Please check.
>        if(!mcastFilterSize_p) {>                printk(KERN_ERR "(%s:%3.3d) ERROR: Can't find "> diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c> index cf25eb4..eb01dd9 100644> --- a/drivers/net/typhoon.c> +++ b/drivers/net/typhoon.c> @@ -872,7 +872,7 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)>                        typhoon_inc_tx_index(&txRing->lastWrite, 1);>>                        len = frag->size;> -                       frag_addr = (void *) page_address(frag->page) +> +                       frag_addr = page_address(frag->page) +>                                                frag->page_offset;I think this cast was intentional too, because of the pointer arithmetic.
>                        skb_dma = pci_map_single(tp->tx_pdev, frag_addr, len,>                                         PCI_DMA_TODEVICE);> diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c> index fb53ef8..58c1dd8 100644> --- a/drivers/net/via-velocity.c> +++ b/drivers/net/via-velocity.c> @@ -2136,7 +2136,7 @@ static int velocity_xmit(struct sk_buff *skb, struct net_device *dev)>>                        for (i = 0; i < nfrags; i++) {>                                skb_frag_t *frag = &skb_shinfo(skb)->frags[i];> -                               void *addr = (void *)page_address(frag->page) + frag->page_offset;> +                               void *addr = page_address(frag->page) + frag->page_offset;Dito.
>>                                tdinfo->skb_dma[i + 1] = pci_map_single(vptr->pdev, addr, frag->size, PCI_DMA_TODEVICE);>> diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c> index 8face5d..83a9489 100644> --- a/drivers/net/wan/dscc4.c> +++ b/drivers/net/wan/dscc4.c> @@ -771,7 +771,7 @@ static int __devinit dscc4_init_one(struct pci_dev *pdev,>        }>        /* Global interrupt queue */>        writel((u32)(((IRQ_RING_SIZE >> 5) - 1) << 20), ioaddr + IQLENR1);> -       priv->iqcfg = (__le32 *) pci_alloc_consistent(pdev,> +       priv->iqcfg = pci_alloc_consistent(pdev,Endian annotations.
>                IRQ_RING_SIZE*sizeof(__le32), &priv->iqcfg_dma);>        if (!priv->iqcfg)>                goto err_free_irq_5;> @@ -785,7 +785,7 @@ static int __devinit dscc4_init_one(struct pci_dev *pdev,>         */>        for (i = 0; i < dev_per_card; i++) {>                dpriv = priv->root + i;> -               dpriv->iqtx = (__le32 *) pci_alloc_consistent(pdev,> +               dpriv->iqtx = pci_alloc_consistent(pdev,Dito.
>                        IRQ_RING_SIZE*sizeof(u32), &dpriv->iqtx_dma);>                if (!dpriv->iqtx)>                        goto err_free_iqtx_6;> @@ -793,7 +793,7 @@ static int __devinit dscc4_init_one(struct pci_dev *pdev,>        }>        for (i = 0; i < dev_per_card; i++) {>                dpriv = priv->root + i;> -               dpriv->iqrx = (__le32 *) pci_alloc_consistent(pdev,> +               dpriv->iqrx = pci_alloc_consistent(pdev,Dito.
>                        IRQ_RING_SIZE*sizeof(u32), &dpriv->iqrx_dma);>                if (!dpriv->iqrx)>                        goto err_free_iqrx_7;> diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c> index 97e5647..71335a8 100644> --- a/drivers/net/wireless/ipw2x00/ipw2100.c> +++ b/drivers/net/wireless/ipw2x00/ipw2100.c> @@ -4301,8 +4301,7 @@ static int status_queue_allocate(struct ipw2100_priv *priv, int entries)>        IPW_DEBUG_INFO("enter\n");>>        q->size = entries * sizeof(struct ipw2100_status);> -       q->drv => -           (struct ipw2100_status *)pci_alloc_consistent(priv->pci_dev,> +       q->drv = pci_alloc_consistent(priv->pci_dev,>                                                          q->size, &q->nic);Please check.
>        if (!q->drv) {>                IPW_DEBUG_WARNING("Can not allocate status queue.\n");> --Bert���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
