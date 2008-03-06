Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYCFNLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYCFNLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYCFNLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:11:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46366 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYCFNLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:11:38 -0500
Date: Thu, 6 Mar 2008 14:11:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
Message-ID: <20080306131119.GC21359@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com> <20080305134150.GA16477@elte.hu> <20080306075223.BA28B2700FD@magilla.localdomain> <20080306112819.GC17906@elte.hu> <20080306120309.E4BE52700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306120309.E4BE52700FD@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> I know.  That completely misses the point I just made:
> 
>    As I said then, one of my concerns was with the low-level tweaks 
>    not yet sufficiently baked, independent from my reservations about 
>    the ptrace feature.  Your #if'ing out of the user ABI additions for 
>    2.6.25 does nothing to remove the unknown new risks from all the 
>    tweaks with fingers in the low-level arch stuff.  This is the sort 
>    of thing I was concerned about.
> 
> You didn't revert the parts that ever could have caused problems for 
> anyone except those using the new ptrace extensions, i.e. changes to 
> step.c, context switch, whatever else was touched we've lost track of 
> now.  I keep saying that those are not baked, 100% independent of the 
> ptrace feature.  You don't seem to be hearing me.

well the issue is that both regset and bts had regressions, so the 
safest was to do the minimal step of undoing any externally visible 
changes. Feel free to send a reverter patch for the other lowlevel bts 
bits as well.

	Ingo
