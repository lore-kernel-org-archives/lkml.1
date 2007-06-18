Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbXFRO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbXFRO4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXFRO43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:56:29 -0400
Received: from saeurebad.de ([85.214.36.134]:45127 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbXFRO42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:56:28 -0400
Date: Mon, 18 Jun 2007 16:56:22 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: dj@david-web.co.uk
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Sound plays at half speed; intel8x0 clock issue
Message-ID: <20070618145622.GA28145@saeurebad.de>
Mail-Followup-To: dj@david-web.co.uk,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706181337.43868.dj@david-web.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706181337.43868.dj@david-web.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 18, 2007 at 01:37:43PM +0100, David Johnson wrote:
> I'm running vanilla 2.6.21.5 on a Winfast NF4UK8AA motherboard and sound is 
> playing at half-speed.
> 
> I get the following output in dmesg:
> intel8x0_measure_ac97_clock: measured 51345 usecs
> intel8x0: measured clock 29136 rejected
> intel8x0: clocking to 48000
> 
> lspci says:
> 00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio 
> Controller (rev a2)
> 
> I've tried passing various ac97_clock values but it seems to have no effect. 
> I've also tried setting ac97_quirk but that doesn't help either.
> 
> I attach my full dmesg and .config. Please let me know if I can provide more 
> information or help debug this.

dmesg:

[SNIP]
>   DMA32 zone: 3527 pages used for memmap
>   DMA32 zone: 254505 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
> Nvidia board detected. Ignoring ACPI timer override.
> If you got timer trouble try acpi_use_timer_override
[SNAP]

Perhaps you might want to try the acpi_use_timer_override bootflag?

	Hannes
