Return-Path: <linux-kernel-owner+w=401wt.eu-S965496AbXA3OWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496AbXA3OWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965472AbXA3OWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:22:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46884 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965468AbXA3OWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:22:02 -0500
Date: Tue, 30 Jan 2007 14:31:56 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: ethanhsiao@jmicron.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, alan@redhat.com
Subject: Re: [PATCH -mm] jmicron: 40/80pin primary detection
Message-ID: <20070130143156.41480254@localhost.localdomain>
In-Reply-To: <OF59067410.11A20F48-ON48257273.00150F04@jmicron.com>
References: <OF59067410.11A20F48-ON48257273.00150F04@jmicron.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  	case PORT_PATA0:
>  		if (control & (1 << 3))	/* 40/80 pin primary */
> -			return 1;
> -		return 0;
> +			return 0;
> +		return 1;

Ack

> @@ -205,11 +205,11 @@
>  }
>  
>  static struct pci_device_id jmicron_pci_tbl[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361), 0},
> -	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363), 1},
> -	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365), 2},
> -	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366), 3},
> -	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368), 4},
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
> +	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
>  	{ 0, },

That should have been fixed a while ago with the others that had that
same bug. Must have escaped somewhere.

Acked-by: Alan Cox <alan@redhat.com>
