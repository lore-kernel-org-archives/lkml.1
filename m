Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZHRKPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZHRKPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZHRKPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:15:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZHRKPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:15:37 -0400
Date: Tue, 18 Aug 2009 12:15:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Kelly <mark@bifferos.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2] x86: CPU detection for RDC
Message-ID: <20090818101525.GB14374@elte.hu>
References: <20090816175204.GA28553@elte.hu> <alpine.LNX.2.00.0908160404300.20653@cent.localnet> <4A899A1D.8060808@zytor.com> <20090817180825.GA5558@elte.hu> <4A899FEA.9020707@zytor.com> <871vnas2gn.fsf@basil.nowhere.org> <4A89A724.406@zytor.com> <20090817213118.GA24747@one.firstfloor.org> <4A89D300.5030509@zytor.com> <alpine.LNX.2.00.0908170746040.28730@cent.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0908170746040.28730@cent.localnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0127]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Kelly <mark@bifferos.com> wrote:

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -382,6 +382,7 @@ config X86_RDC321X
>  	bool "RDC R-321x SoC"
>  	depends on X86_32
>  	depends on X86_EXTENDED_PLATFORM
> +	select PCI
>  	select M486
>  	select X86_REBOOTFIXUPS

PCI is a complex interactive Kconfig switch and we dont select it 
in x86 code. Please add a 'depends on PCI' line instead, as i 
suggested in my mail.

	Ingo
