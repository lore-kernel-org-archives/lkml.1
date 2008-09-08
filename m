Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYIHNkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYIHNkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYIHNkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:40:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbYIHNkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:40:35 -0400
Date: Mon, 8 Sep 2008 15:40:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
Message-ID: <20080908134019.GB11993@elte.hu>
References: <48C13D1C.76E4.0078.0@novell.com> <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C51F8D.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 05.09.08 17:00 >>>
> >
> >* Jan Beulich <jbeulich@novell.com> wrote:
> >
> >> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> >> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
> >> 
> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >> 
> >> ---
> >>  arch/x86/kernel/cpu/common.c |   17 +++++++++++++++++
> >>  arch/x86/mm/ioremap.c        |   15 ++++++---------
> >>  include/asm-x86/processor.h  |    4 ++--
> >>  3 files changed, 25 insertions(+), 11 deletions(-)
> >
> >hm, the cpu/common.c bits just got reworked massively in tip/master. 
> >I've tried a blind merge (see the patch below) but at least the first 
> >hunk looks wrong. Mind looking at how to merge this?
> 
> This is my take at it:
> 
> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.

applied to tip/x86/mm-debug - thanks Jan!

	Ingo
