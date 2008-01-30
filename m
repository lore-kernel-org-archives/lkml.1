Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYA3KXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYA3KXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759944AbYA3KVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:21:19 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42058 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759900AbYA3KVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:21:17 -0500
Date: Wed, 30 Jan 2008 11:21:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
Message-ID: <20080130102116.GA20846@uranus.ravnborg.org>
References: <20080130094440.GA4652@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130094440.GA4652@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Jeff Garzik (1):
>       [netdrvr] sis190: build fix

But you did it wrong...
sis190.c b/drivers/net/sis190.c
> index b570402..2e9e88b 100644
> --- a/drivers/net/sis190.c
> +++ b/drivers/net/sis190.c
> @@ -326,7 +326,7 @@ static const struct {
>  	{ "SiS 191 PCI Gigabit Ethernet adapter" },
>  };
>  
> -static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
> +static struct pci_device_id sis190_pci_tbl[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
>  	{ 0, },

The __devinitdata is OK, it is the following _devinitdata that had to be _devinitconst.

	Sam
