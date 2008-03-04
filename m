Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbYCDUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbYCDUyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYCDUyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:54:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYCDUyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:54:10 -0500
Date: Tue, 4 Mar 2008 21:53:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v3
Message-ID: <20080304205353.GA31546@elte.hu>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080304102804.GA17681@elte.hu> <20080304175909.GE28006@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304175909.GE28006@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> >   v3: Fixed the non-atomic calling sequence in atomic context.
> > 
> > is that the same bug?
> 
> Yes. Sorry for not pointing out explicitly. Essentially 32bit kernel 
> with CONFIG_PREEMPT is calling math_state_restore() with interrupts 
> disabled. Handled this by enabling/disabling the interrupts around the 
> blocking call. with small code changes ensuring that it is safe to 
> enable/disable interrupts at this point.
> 
> Do you want a v4 or separate patch for handling the kmem_cache_alloc() 
> failure

would be nice to resend a v4 - i couldnt pick v3 up due to the pending 
questions. (the NULL thing was quite serious)

	Ingo
