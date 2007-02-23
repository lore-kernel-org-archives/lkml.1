Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbXBWNro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbXBWNro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932365AbXBWNro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:47:44 -0500
Received: from gherkin.frus.com ([192.158.254.49]:49237 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbXBWNrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:47:43 -0500
Subject: Re: natsemi: Fix detection of vanilla natsemi cards
In-Reply-To: <20070223113209.GB9282@sirena.org.uk> "from Mark Brown at Feb 23,
 2007 11:32:11 am"
To: Mark Brown <broonie@sirena.org.uk>
Date: Fri, 23 Feb 2007 07:47:40 -0600 (CST)
CC: Andrew Morton <akpm@linux-foundation.org>, Tim Hockin <thockin@hockin.org>,
       Jeff Garzik <jgarzik@pobox.com>, Adrian Bunk <bunk@stusta.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070223134740.E5ECADBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> (Re: vanilla natsemi card detection problem)
> This patch fixes the problem minimally.
> 
> Signed-Off-By: Mark Brown <broonie@sirena.org.uk>
> 
> --- linux.orig/drivers/net/natsemi.c	2007-02-23 11:13:03.000000000 +0000
> +++ linux/drivers/net/natsemi.c	2007-02-23 11:12:00.000000000 +0000
> @@ -260,7 +260,7 @@
>  
>  static const struct pci_device_id natsemi_pci_tbl[] __devinitdata = {
>  	{ PCI_VENDOR_ID_NS, 0x0020, 0x12d9,     0x000c,     0, 0, 0 },
> -	{ PCI_VENDOR_ID_NS, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }
> +	{ PCI_VENDOR_ID_NS, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1 },
>  	{ }	/* terminate list */
>  };
>  MODULE_DEVICE_TABLE(pci, natsemi_pci_tbl);
> 

ACK except for a missing comma at the end of the line being replaced,
which prevents the patch from applying cleanly.  Otherwise, this fixes
the problem I was having.  Thanks!

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
