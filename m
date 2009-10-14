Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZJNSvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZJNSvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZJNSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:51:44 -0400
Received: from khc.piap.pl ([195.187.100.11]:39577 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZJNSvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:51:43 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stefan Assmann <sassmann@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx, ddutile@redhat.com
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>
Date: Wed, 14 Oct 2009 20:51:04 +0200
In-Reply-To: <4AD58EEE.4070405@redhat.com> (Stefan Assmann's message of "Wed,
	14 Oct 2009 10:42:22 +0200")
Message-ID: <m3ljjdstbb.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Assmann <sassmann@redhat.com> writes:

> IMHO this is rather confusing, as most people don't know what GT/s means.

It's trivial to look it up, isn't it?

> So I'd suggest the following change:
>
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -86,8 +86,8 @@ static char *pci_bus_speed_strings[] = {
>  	"66 MHz PCIX 533",	/* 0x11 */
>  	"100 MHz PCIX 533",	/* 0x12 */
>  	"133 MHz PCIX 533",	/* 0x13 */
> -	"2.5 GT/s PCI-E",	/* 0x14 */
> -	"5.0 GT/s PCI-E",	/* 0x15 */
> +	"2.5 Gbps PCI-E",	/* 0x14 */
> +	"5.0 Gbps PCI-E",	/* 0x15 */

Isn't it like calling 100BASE-TX a 125 Mb/s? _That_ would be confusing.
BTW PCI-E can be multi-lane so Mb/s (and even MB/s) don't make sense.
I guess many people don't know what a MHz is either but we don't say
133 MHz = 133 Mbps.
-- 
Krzysztof Halasa
