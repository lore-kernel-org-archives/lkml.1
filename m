Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbXF2U1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbXF2U1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXF2U0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:26:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:42357 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753481AbXF2U0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:26:52 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/WNX0S8S3WwWclrDJz7MWGW9Z7V42FCndVk/XeIJ
	dFsWrPfC2HryKM
Date: Fri, 29 Jun 2007 22:26:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: skyball000@freesurf.fr
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rt9 problem : xruns
In-Reply-To: <48440.194.254.4.171.1183116296.squirrel@jose.freesurf.fr>
Message-ID: <Pine.LNX.4.60.0706292225400.4227@poirot.grange>
References: <48440.194.254.4.171.1183116296.squirrel@jose.freesurf.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 skyball000@freesurf.fr wrote:

> Hi,
> 
> I've recently compiled a "vanilla" 2.6.21 kernel, patched with Ingo Molnar's
> rt-8 patch, as I was unable to compile with rt-7.
> 
> I needed it because I'm using audio applications (tests were made with
> FrugalWare, but I don't think it's a distro issue).
> 
> Everything was allright until I changed my motherboard for an  Asrock
> 4coreDual-Vsta (I formerly used a Nforce4 one), with VIA PT880 Ultra chipset.
> 
> I've justed switched the hardware, as Linux is neat enough to boot without
> having to reinstall the whole OS.
> 
> Since, I get tons of xruns when using RT applications, and the only solution
> I've found to "fix" it was to disable ACPI at boot time.

Interestingly, this looks very similar to a problem I had... Could you, 
please, verify if acpid is running (with ACPI configured on), and if yes - 
stop it and retest for xruns?

Thanks
Guennadi

> Moreover, I get this message at boot time :
> PCI: BIOS bug: MCFG area@e0000000 is not E820 reserved
> PCI: not using MMCONFIG
> 
> I've also tested this hardware setup with a UbuntoStudio kernel (2.6.19),
> and everything works flawlessy (no XRUNS, no kernel messages) !
> 
> So here is my question (I'd like to understand what's happening) :
>    - is it a kernel (or patch) issue ?
>    - is it a bad chipset support in the latest kernel versions ?
>    - could this be related to BIOS issues only (I've tried all available
> versions without any change) ?
>    - should I use special settings in the ".config" in order to avoid these
> problems ?
> 
> I wasn't able to detect what causes these XRUNS, so if anyone has clues ...
> 
> Regards
> skb
> 
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski
