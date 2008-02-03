Return-Path: <linux-kernel-owner+w=401wt.eu-S936487AbYBCJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936487AbYBCJuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761204AbYBCJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:50:26 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:39324 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761008AbYBCJuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:50:25 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2008 04:50:25 EST
From: Frank Seidel <frank@f-seidel.de>
To: Denis Cheng <crquan@gmail.com>
Subject: Re: [PATCH] drivers/block/: add __devinitdata to all pci_device_id table of block drivers
Date: Sun, 3 Feb 2008 10:43:41 +0100
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <1202008347-5407-1-git-send-email-crquan@gmail.com>
In-Reply-To: <1202008347-5407-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031043.41724.frank@f-seidel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 February 2008 04:12, Denis Cheng wrote:
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -67,7 +67,7 @@ MODULE_LICENSE("GPL");
>  #include <linux/cciss_ioctl.h>
>  
>  /* define the PCI info for the cards we can control */
> -static const struct pci_device_id cciss_pci_device_id[] = {
> +static const struct pci_device_id cciss_pci_device_id[] __devinitdata = {

it should be __devinitconst here

> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -96,7 +96,7 @@ static struct board_type products[] = {
>  };
>  
>  /* define the PCI info for the PCI cards this driver can control */
> -static const struct pci_device_id cpqarray_pci_device_id[] =
> +static const struct pci_device_id cpqarray_pci_device_id[] __devinitdata =

same here

> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -1053,7 +1053,7 @@ static void mm_pci_remove(struct pci_dev *dev)
>  	pci_disable_device(dev);
>  }
>  
> -static const struct pci_device_id mm_pci_ids[] = {
> +static const struct pci_device_id mm_pci_ids[] __devinitdata = {

same here

Thanks,
Frank
