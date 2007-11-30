Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXK3Lee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXK3Lee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbXK3LeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:34:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34196 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbXK3LeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:34:21 -0500
Date: Fri, 30 Nov 2007 12:34:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 09/11] x86 ia32 ptrace arch merge
Message-ID: <20071130113403.GA8190@elte.hu>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129120041.8621A26F989@magilla.localdomain> <20071129205852.GA1726@martell.zuzino.mipt.ru> <20071129213705.35E2826F8E7@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129213705.35E2826F8E7@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> > On Thu, Nov 29, 2007 at 04:00:41AM -0800, Roland McGrath wrote:
> > > This moves the sys32_ptrace code into arch/x86/kernel/ptrace.c,
> > > verbatim except for a few hard-coded sizes replaced with sizeof.
>     ^^^^^^^^
> >[...]
> 
> I just moved this code, I didn't change it.  So let's leave style (or 
> other) problems with the existing code for a next round and not hold 
> up the moving/merging because of them.

yep - cleanups should then be posted against the unified codebase. (it's 
simpler that way)

	Ingo
