Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYIESi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYIESi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYIESiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:38:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbYIESiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:38:51 -0400
Date: Fri, 5 Sep 2008 20:38:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080905183835.GA19215@elte.hu>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905183347.GB19334@lenovo>
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

> So as you see it's more then enough self-solid :) So I wouldn't break 
> it 'cause of printing. If we have enough memory for bit field - we 
> could just mark there if pin is connected to irq and print connection 
> map after. Don't get me wrong please - I just don't want to overload 
> this function with additional call.

the compiler will inline that single-called function just fine, as long 
as you declare it static.

spreading printouts over several functions isnt all that bad i think. We 
could even drop the 'not connected' complication - it's evident enough 
from the fact that nothing gets printed.

	Ingo
