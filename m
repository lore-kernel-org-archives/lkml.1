Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZJZNSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZJZNSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZJZNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:18:13 -0400
Received: from khc.piap.pl ([195.187.100.11]:47523 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbZJZNSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:18:12 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stefan Assmann <sassmann@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH] PCI hotplug: use correct term for PCI Express
References: <4AE59AE9.6030803@redhat.com>
Date: Mon, 26 Oct 2009 14:18:15 +0100
In-Reply-To: <4AE59AE9.6030803@redhat.com> (Stefan Assmann's message of "Mon,
	26 Oct 2009 13:49:45 +0100")
Message-ID: <m3my3emgyw.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann <sassmann@redhat.com> writes:

> Change PCI-E to PCIe which is the correct term according to
> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf.

Right.

> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -86,8 +86,8 @@ static char *pci_bus_speed_strings[] = {
>  	"66 MHz PCIX 533",	/* 0x11 */
>  	"100 MHz PCIX 533",	/* 0x12 */
>  	"133 MHz PCIX 533",	/* 0x13 */
> -	"2.5 GT/s PCI-E",	/* 0x14 */
> -	"5.0 GT/s PCI-E",	/* 0x15 */
> +	"2.5 GT/s PCIe",	/* 0x14 */
> +	"5.0 GT/s PCIe",	/* 0x15 */

In addition to this, it seems "PCIX" should also be changed to "PCI-X",
shouldn't it?
-- 
Krzysztof Halasa
