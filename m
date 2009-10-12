Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZJLJs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZJLJs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbZJLJs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:48:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbZJLJs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:48:56 -0400
Date: Mon, 12 Oct 2009 11:48:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc4
Message-ID: <20091012094806.GB928@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012082950.GA2270@elte.hu> <20091012133418.GB4900@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012133418.GB4900@x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0035]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Oct 12, 2009 at 10:29:50AM +0200, Ingo Molnar wrote:
> > Alexey, could you please Cc: affected maintainers in the future, so that 
> > we can avoid such problems?
> 
> And can you merge fallout your compile farm found into single 
> "fallout" patch. Inflating number of commits doesn't really help.

i found them separately and fixed them gradually so obviously they are 
separate commits done separately.

It's useful to have patches split up in general, so that maintainers can 
pick up each fix independently. (Also, should any of them be in the need 
of reverting it's far easier to do it than to revert a mega patch.)

	Ingo
