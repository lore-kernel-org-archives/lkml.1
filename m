Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYFFKaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYFFKaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYFFK3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:29:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50806 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753580AbYFFK3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:29:52 -0400
Date: Fri, 6 Jun 2008 11:14:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Catalin(ux) M BOIE" <catab@embedromix.ro>
Cc: linux-kernel@vger.kernel.org, rmk+serial@arm.linux.org.uk,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] Add support for a no-name 4 ports multiserial card
Message-ID: <20080606111400.1eefc4fd@core>
In-Reply-To: <1212736393-6837-1-git-send-email-catab@embedromix.ro>
References: <1212736393-6837-1-git-send-email-catab@embedromix.ro>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Jun 2008 10:13:13 +0300
"Catalin(ux) M BOIE" <catab@embedromix.ro> wrote:

> It is a no-name PCI card. I found no reference to a producer so I
> used the fake name "PDR".

We don't really want to get fake names into pci_ids. I'd rather


>  		.vendor		= PCI_VENDOR_ID_PLX,
> +		.device		= PCI_DEVICE_ID_PLX_9050,
> +		.subvendor	= PCI_VENDOR_ID_PLX,
> +		.subdevice	= PCI_SUBDEVICE_ID_PDR,

Either the hex or a local and obviously unknown name like ID_UNKNOWN_1


> +	pbn_plx_pdr,

_unknown1

>  	pbn_oxsemi,
>  	pbn_intel_i960,
>  	pbn_sgi_ioc3,
> @@ -1186,6 +1196,13 @@ static struct pciserial_board pci_boards[] __devinitdata = {
>  		.base_baud	= 115200,
>  		.uart_offset	= 8,
>  	},
> +	/* PDR */
> +	[pbn_plx_pdr] = {

Ditto

> +	/* PDR */

Ditto

> +	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
> +		PCI_VENDOR_ID_PLX,
> +		PCI_SUBDEVICE_ID_PDR, 0, 0,

Ditto


> +#define PCI_SUBDEVICE_ID_PDR		0x1584
> +

And not in here at all.

Alan
