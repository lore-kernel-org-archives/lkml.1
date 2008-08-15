Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYHOOrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYHOOrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYHOOri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:47:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYHOOrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:47:37 -0400
Date: Fri, 15 Aug 2008 16:47:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, tglx@linutronix.de,
       hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
Message-ID: <20080815144721.GK12954@elte.hu>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com> <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl> <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com> <20080815115147.GA32726@elte.hu> <Pine.LNX.4.55.0808151303410.11843@cliff.in.clinika.pl> <20080815134801.GA14103@elte.hu> <20080815144509.GA7178@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815144509.GA7178@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> And Maciej - you're so right - if someone will take a look on the 
> apic_64.c code now he will be quite wondered what lapic_is_integrated 
> is doing in 64bit code.
> 
> Ingo, I don't know but maybe you should drop the patches I sent since 
> they could (espec the snippet Maciej pointed to) confuse code reader 
> (sine merging process is not completed yet). Sorry for incovenience 
> and thanks again for review!

no problem with having such temporary state at all - and we want to test 
things out as well.

	Ingo
