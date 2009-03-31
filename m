Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbZCaD0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbZCaD0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZCaD0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:26:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54358 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbZCaD0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:26:38 -0400
Message-ID: <49D18D60.2050404@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 12:26:24 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] PCI: allow PCI core hotplug to remove PCI root
 bus
References: <20090330164737.18855.7137.stgit@bob.kio> <20090330165009.18855.43672.stgit@bob.kio>
In-Reply-To: <20090330165009.18855.43672.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Thanks,
Kenji Kaneshige


Alex Chiang wrote:
> There is no reason to prevent removal of root bus devices. A subsequent
> rescan will find them just fine.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/pci-sysfs.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index e9a8706..7b2cb27 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -277,14 +277,10 @@ remove_store(struct device *dev, struct device_attribute *dummy,
>  {
>  	int ret = 0;
>  	unsigned long val;
> -	struct pci_dev *pdev = to_pci_dev(dev);
>  
>  	if (strict_strtoul(buf, 0, &val) < 0)
>  		return -EINVAL;
>  
> -	if (pci_is_root_bus(pdev->bus))
> -		return -EBUSY;
> -
>  	/* An attribute cannot be unregistered by one of its own methods,
>  	 * so we have to use this roundabout approach.
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


