Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYHONsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYHONsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYHONsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:48:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbYHONsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:48:17 -0400
Date: Fri, 15 Aug 2008 15:48:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, tglx@linutronix.de, hpa@zytor.com,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
Message-ID: <20080815134801.GA14103@elte.hu>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com> <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl> <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com> <20080815115147.GA32726@elte.hu> <Pine.LNX.4.55.0808151303410.11843@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0808151303410.11843@cliff.in.clinika.pl>
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

> > If that was the question, the answer would be: to unify apic_32.c 
> > and apic_64.c we first use tiny little changes to bring the two 
> > files in sync. Presumably, each such change is a NOP or at least 
> > very safe - and clearly bisectable in the worst-case.
> 
>  If the obfuscation comes from apic_64.c, then the clean-up should be 
> done in th other direction IMO.  Not everything that comes from the 
> 64-bit variation is better than its 32-bit counterpart.

yeah - in fact for most unifications we did the 32-bit counterpart was 
the cleaner one. (which is no big surprise, 80%-90% of the x86 Linux 
use, even today, is on the 32-bit side - so most developers watch that 
one.)

	Ingo
