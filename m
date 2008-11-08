Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYKHTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYKHTlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYKHTlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:41:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYKHTlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:41:05 -0500
Date: Sat, 8 Nov 2008 20:40:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081108194055.GA30892@elte.hu>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org> <20081108190517.GA9806@elte.hu> <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 8 Nov 2008, Ingo Molnar wrote:
> > 
> > So that's why my change moves it from the __native_read_tsc() over 
> > to _only_ the vget_cycles().
> 
> Ahh. I was looking at native_read_tscp(). Which has no barriers. But 
> then we don't actually save the actual TSC, we only end up using the 
> "p" part, so we don't care..

sidenote #3: RDTSCP is a relatively new instruction, and has implicit 
barrier properties: it is a serializing instruction.

	Ingo
