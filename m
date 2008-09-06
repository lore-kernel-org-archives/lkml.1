Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYIFNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYIFNMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYIFNMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 09:12:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33516 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYIFNMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 09:12:31 -0400
Date: Sat, 6 Sep 2008 15:12:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080906131217.GA4910@elte.hu>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906101533.GA7273@lenovo>
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

> By changing printout form we are able to shrink code a bit.
> 
> Former printout example:
> 
> 	init IO_APIC IRQs
> 	 IO-APIC (apicid-pin) 1-1, 1-2, 1-3 not connected.
> 	 IO-APIC (apicid-pin) 2-1, 2-2, 2-3 not connected.
> 
> New printout example:
> 
> 	init IO_APIC IRQs
> 	 1-1 1-2 1-3 (apicid-pin) not connected
> 	 2-1 2-2 2-3 (apicid-pin) not connected

applied to tip/irq/sparseirq - thanks Cyrill.

	Ingo
