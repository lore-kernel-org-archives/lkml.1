Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbXKGCd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbXKGCd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbXKGCdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:33:19 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4015 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbXKGCdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:33:18 -0500
Date: Tue, 6 Nov 2007 21:32:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, mb@bu3sch.de
Subject: Re: [PATCH 1/2] ssb: Add "ssb_pci_set_power_state" function
Message-ID: <20071107023253.GA30169@tuxdriver.com>
References: <200710242131.21959.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710242131.21959.mboton.lkml@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel,

Along with the style point Michael suggested, I'll need you to repost
both this one and the b44 patch with at least a Signed-off-by line.

	http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

Also, please include the patches as plain text using a mailer that
does not damage whitespace.

Thanks,

John

On Wed, Oct 24, 2007 at 09:31:21PM +0200, Miguel Botón wrote:
> Add "ssb_pci_set_power_state" function. This allows set the power state of a 
> PCI device (for example b44 ethernet device).
> 
> diff -ruN linux-2.6.23/include/linux/ssb/ssb.h 
> linux-2.6.23.orig/include/linux/ssb/ssb.h
> --- linux-2.6.23.orig/include/linux/ssb/ssb.h	2007-10-24 19:02:33.000000000 
> +0200
> +++ linux-2.6.23/include/linux/ssb/ssb.h	2007-10-24 19:49:37.000000000 +0200
> @@ -402,6 +402,14 @@
>  {
>  	pci_unregister_driver(driver);
>  }
> +
> +/* Set PCI device power state */
> +static inline
> +void ssb_pci_set_power_state(struct ssb_device *dev, pci_power_t state)
> +{
> +	if(dev->bus->bustype == SSB_BUSTYPE_PCI)
> +		pci_set_power_state(dev->bus->host_pci, state);
> +}
>  #endif /* CONFIG_SSB_PCIHOST */
>  
>  
> 
> -- 
> 	Miguel Botón

-- 
John W. Linville
linville@tuxdriver.com
