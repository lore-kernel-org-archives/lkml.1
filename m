Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZKQWxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZKQWxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbZKQWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:53:09 -0500
Received: from lucidpixels.com ([75.144.35.66]:44354 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbZKQWxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:53:07 -0500
Date: Tue, 17 Nov 2009 17:53:12 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <20091117213711.GA19132@linux-os.sc.intel.com>
Message-ID: <alpine.DEB.2.00.0911171750420.3800@p34.internal.lan>
References: <1258069232.14894.9.camel@localhost.localdomain> <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain> <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan> <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain> <1258137165.21141.20.camel@localhost.localdomain> <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan> <1258161139.21141.29.camel@localhost.localdomain> <alpine.DEB.2.00.0911140344430.29547@p34.internal.lan>
 <alpine.DEB.2.00.0911170643430.25285@p34.internal.lan> <20091117213711.GA19132@linux-os.sc.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Nov 2009, Pallipadi, Venkatesh wrote:

> On Tue, Nov 17, 2009 at 03:45:31AM -0800, Justin Piszcz wrote:
> +		WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
>
> 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
> }
> -- 
> 1.6.0.6

Hi, that omits the message @ boot and you are correct, all is/continues to work fine.

Thanks..

As far as the DP55KG reboots, the workaround is set append="reboot=a" -
will a BIOS fix address this (other) issue? Try rebooting Linux without 
any special parameters (2.6.30+) and the DP55KG will hang at reboot
(note, shutdown does shut the machine off).

Justin.

