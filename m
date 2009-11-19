Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZKSWIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZKSWIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZKSWIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:08:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:31202 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbZKSWIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:08:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,773,1249282800"; 
   d="scan'208";a="213602514"
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.DEB.2.00.0911171750420.3800@p34.internal.lan>
References: <1258069232.14894.9.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain>
	 <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>
	 <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
	 <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain>
	 <1258137165.21141.20.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan>
	 <1258161139.21141.29.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0911140344430.29547@p34.internal.lan>
	 <alpine.DEB.2.00.0911170643430.25285@p34.internal.lan>
	 <20091117213711.GA19132@linux-os.sc.intel.com>
	 <alpine.DEB.2.00.0911171750420.3800@p34.internal.lan>
Content-Type: text/plain
Date: Thu, 19 Nov 2009 14:08:43 -0800
Message-Id: <1258668523.21141.109.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 14:53 -0800, Justin Piszcz wrote:
> 
> On Tue, 17 Nov 2009, Pallipadi, Venkatesh wrote:
> 
> > On Tue, Nov 17, 2009 at 03:45:31AM -0800, Justin Piszcz wrote:
> > +		WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
> >
> > 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
> > }
> > -- 
> > 1.6.0.6
> 
> Hi, that omits the message @ boot and you are correct, all is/continues to work fine.
> 
> Thanks..
> 
> As far as the DP55KG reboots, the workaround is set append="reboot=a" -
> will a BIOS fix address this (other) issue? Try rebooting Linux without 
> any special parameters (2.6.30+) and the DP55KG will hang at reboot
> (note, shutdown does shut the machine off).
> 

I haven't seen this reboot problem on my test system here. So, I don't
know what the problem is. Probably some BIOS issue.

Does "reboot=b" work? Quickest solution will be to add platform dmi
entry in reboot.c and workaround this.

Thanks,
Venki

