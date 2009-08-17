Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbZHQR6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbZHQR6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932297AbZHQR63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:58:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbZHQR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:58:29 -0400
Message-ID: <4A899A1D.8060808@zytor.com>
Date: Mon, 17 Aug 2009 10:57:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mark Kelly <mark@bifferos.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
References: <58001.1250437590@bifferos.com> <20090816155507.GA2791@elte.hu> <alpine.LNX.2.00.0908160317250.19588@cent.localnet> <20090816175204.GA28553@elte.hu> <alpine.LNX.2.00.0908160404300.20653@cent.localnet>
In-Reply-To: <alpine.LNX.2.00.0908160404300.20653@cent.localnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2009 08:35 PM, Mark Kelly wrote:
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 4e242f9..9906064 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
>  obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
>  obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
>  obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
> +obj-$(CONFIG_X86_RDC321X)		+= rdc.o
> 
>  obj-$(CONFIG_X86_MCE)	+= mcheck/
>  obj-$(CONFIG_MTRR)	+= mtrr/

I don't see this defined anywhere.  Where it is defined, it needs to
depend on or select CONFIG_PCI, since the detection code you're
proposing is using unguarded PCI references.

	-hpa
