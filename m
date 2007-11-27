Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbXK0XGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbXK0XGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbXK0XFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:05:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760260AbXK0XF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:05:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/27] ptrace: arch_has_single_step
In-Reply-To: Andrew Morton's message of  Tuesday, 27 November 2007 00:53:29 -0800 <20071127005329.9dfcf473.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20071125215507.4B89226F8C5@magilla.localdomain>
	<20071127005329.9dfcf473.akpm@linux-foundation.org>
X-Shopping-List: (1) Nosy riots
   (2) Outrageous hands
   (3) Photogenic salmon
Message-Id: <20071127230521.67FF626F8C5@magilla.localdomain>
Date: Tue, 27 Nov 2007 15:05:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think I'll duck this lot for now in view of the (relatively small) amount
> of followup.

The debugctlmsr bits (last few patches) are meant to be taken with a grain
of salt.  Everything else in this set is pretty well ready for prime time.

> I did do an experimental will-it-apply and got a tremendous number of
> rejects against the x86 git tree, almost all of which went away when `patch
> -l' was used.  Seems that someone has gone on a whitespace rampage through
> arch/x86/ia32/ptrace32.c and arch/x86/ia32/ptrace64.c.

Damn, sorry about that.  I could have sworn I cranked everything through
the whitespace inoculation machine, but I guess I missed some.


Thanks,
Roland
