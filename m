Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYKJIRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYKJIRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYKJIR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:17:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36371 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYKJIR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:17:26 -0500
Date: Mon, 10 Nov 2008 09:17:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] x86: apic - calibrate_APIC_clock remove redundant
	irq-enable-disable
Message-ID: <20081110081709.GA17498@elte.hu>
References: <20081109105709.222708517@gmail.com>> <4916c290.0437560a.270e.0940@mx.google.com> <alpine.LFD.1.10.0811091245000.25325@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0811091245000.25325@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:
> 
> > Impact: cleanup
> > 
> > lapic_timer_setup is self-protected with local_irq_save/restore
> > no need to use them in caller and levt is the per-cpu variable so
> > no concurrent access from another cpu.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> >  arch/x86/kernel/apic.c |    4 ----
> >  1 file changed, 4 deletions(-)
> 
> Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
> 
>  Thanks, Cyrill.

applied to tip/x86/apic, thanks guys!

	Ingo
