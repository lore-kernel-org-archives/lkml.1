Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXK0X7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXK0X7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbXK0X7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:59:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbXK0X73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:59:29 -0500
Date: Wed, 28 Nov 2007 00:58:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/27] ptrace: arch_has_single_step
Message-ID: <20071127235847.GA17154@elte.hu>
References: <20071125215507.4B89226F8C5@magilla.localdomain> <20071127005329.9dfcf473.akpm@linux-foundation.org> <20071127230521.67FF626F8C5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127230521.67FF626F8C5@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > I did do an experimental will-it-apply and got a tremendous number 
> > of rejects against the x86 git tree, almost all of which went away 
> > when `patch -l' was used.  Seems that someone has gone on a 
> > whitespace rampage through arch/x86/ia32/ptrace32.c and 
> > arch/x86/ia32/ptrace64.c.
> 
> Damn, sorry about that.  I could have sworn I cranked everything 
> through the whitespace inoculation machine, but I guess I missed some.

i've resolved those and i've added your 27 patches to x86.git. You can 
pick it up from the 'mm' branch of x86.git:

 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

it builds and boots fine here, and the patches certainly look very 
clean. Unless there are major problems with it this looks like 2.6.25 
stuff. Would you mind to send updates/fixes against this tree?

	Ingo
