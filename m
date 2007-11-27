Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbXK0KjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbXK0KjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbXK0KjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:39:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXK0KjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:39:08 -0500
Date: Tue, 27 Nov 2007 11:38:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/27] ptrace: arch_has_single_step
Message-ID: <20071127103846.GF6286@elte.hu>
References: <20071125215507.4B89226F8C5@magilla.localdomain> <20071127005329.9dfcf473.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127005329.9dfcf473.akpm@linux-foundation.org>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 25 Nov 2007 13:55:07 -0800 (PST) Roland McGrath <roland@redhat.com> wrote:
> 
> > This defines the new macro arch_has_single_step() in linux/ptrace.h, 
> > a default for when asm/ptrace.h does not define it.  It declares the 
> > new user_enable_single_step and user_disable_single_step functions. 
> > This is not used yet, but paves the way to harmonize on this 
> > interface for the arch-specific calls on all machines.
> 
> I think I'll duck this lot for now in view of the (relatively small) 
> amount of followup.
> 
> I did do an experimental will-it-apply and got a tremendous number of 
> rejects against the x86 git tree, almost all of which went away when 
> `patch -l' was used.  Seems that someone has gone on a whitespace 
> rampage through arch/x86/ia32/ptrace32.c and arch/x86/ia32/ptrace64.c.
> 
> That's kinda/sorta OK, but `patch -l' is a bit more inclined to 
> misplace hunks and it's all a bit risky.

actually, Thomas tried a tentative merge two days ago or so and the 
result was pretty OK and functional. I'll try to do a more formal merge 
and see what comes up.

	Ingo
