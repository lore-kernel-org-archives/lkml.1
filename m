Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZAFM5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZAFM5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZAFM5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:57:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32877 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZAFM5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:57:32 -0500
Date: Tue, 6 Jan 2009 13:57:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, kosaki.motohiro@jp.fujitsu.com, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: irqnr fallout in gpiolib on sparc32
Message-ID: <20090106125704.GC20407@elte.hu>
References: <20090105133819.GE6014@elte.hu> <20090105134832.GA14460@uranus.ravnborg.org> <20090105135508.GB4190@elte.hu> <20090105.123734.137888898.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105.123734.137888898.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 5 Jan 2009 14:55:08 +0100
> 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > Dave has mentioned this but we are not working actively on it yet.
> > 
> > would be cool to do it - i think sparc32 is one of the last major 
> > physical architectures to not be on genirq -
> 
> m68k remains to be converted over to genirq as well

yeah - but m68k has been a holdout from pretty much every optional core 
kernel facility that has been introduced in the past 5-10 years. So if 
sparc32 converts to genirq we have a stronger case for saying:

   "Convert, else ..."

[ where the three dots stands for something not nice. ]

Sparc32 on the other hand had a clean IRQ layer long before x86 found its 
desire for a clean genirq layer - so genirq is a nuisance for Sparc32 at 
best and it deserves none of the not nice actions. What i am hoping for is 
that perhaps the Sparc unification changed that equation.

	Ingo
