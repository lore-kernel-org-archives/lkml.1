Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZHQSIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZHQSIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZHQSIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:08:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZHQSIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:08:34 -0400
Date: Mon, 17 Aug 2009 20:08:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Kelly <mark@bifferos.com>, linux-kernel@vger.kernel.org,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
Message-ID: <20090817180825.GA5558@elte.hu>
References: <58001.1250437590@bifferos.com> <20090816155507.GA2791@elte.hu> <alpine.LNX.2.00.0908160317250.19588@cent.localnet> <20090816175204.GA28553@elte.hu> <alpine.LNX.2.00.0908160404300.20653@cent.localnet> <4A899A1D.8060808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A899A1D.8060808@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/15/2009 08:35 PM, Mark Kelly wrote:
> > diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> > index 4e242f9..9906064 100644
> > --- a/arch/x86/kernel/cpu/Makefile
> > +++ b/arch/x86/kernel/cpu/Makefile
> > @@ -22,6 +22,7 @@ obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
> >  obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
> >  obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
> >  obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
> > +obj-$(CONFIG_X86_RDC321X)		+= rdc.o
> > 
> >  obj-$(CONFIG_X86_MCE)	+= mcheck/
> >  obj-$(CONFIG_MTRR)	+= mtrr/
> 
> I don't see this defined anywhere.  Where it is defined, it needs 
> to depend on or select CONFIG_PCI, since the detection code 
> you're proposing is using unguarded PCI references.

X86_RDC321X already exists in arch/x86/Kconfig. It should probably 
grow a 'depends on PCI' rline or so.

	Ingo
