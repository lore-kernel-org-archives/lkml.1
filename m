Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYGRM1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYGRM1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYGRM1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:27:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYGRM1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:27:23 -0400
Date: Fri, 18 Jul 2008 14:26:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       Huang Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: v2.6.26-rc9: ACPI PCI irq routing on NUMA? + early_ioremap
	trouble
Message-ID: <20080718122656.GO6875@elte.hu>
References: <19f34abd0807060647k54490088uf8859d8a1646fd41@mail.gmail.com> <200807171245.31641.bjorn.helgaas@hp.com> <19f34abd0807171358p3c5a44f9i91ab23d3f5e9671f@mail.gmail.com> <Pine.LNX.4.55.0807180117320.6536@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807180117320.6536@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> --- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h	2008-07-16 14:50:07.000000000 +0000
> +++ linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h	2008-07-18 00:33:19.000000000 +0000
> @@ -10,7 +10,7 @@
>  
>  #define ARCH_APICTIMER_STOPS_ON_C3	1
>  
> -#define Dprintk(x...)
> +#define Dprintk printk

Maciej, i picked up this change too, as getting more debug output from 
apic=debug seems more than prudent these days ;-)

	Ingo
