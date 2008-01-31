Return-Path: <linux-kernel-owner+w=401wt.eu-S1765905AbYAaKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765905AbYAaKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYAaKZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:25:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbYAaKZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:25:17 -0500
Date: Thu, 31 Jan 2008 11:24:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, heiko.carstens@de.ibm.com,
       linux390@de.ibm.com
Subject: Re: x86 arch updates also broke s390
Message-ID: <20080131102454.GB27157@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131003310.GW29368@does.not.exist> <1201772094.18221.32.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201772094.18221.32.camel@localhost>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Thu, 2008-01-31 at 02:33 +0200, Adrian Bunk wrote:
> > <--  snip  -->
> > 
> > ...
> >   CC      arch/s390/kernel/asm-offsets.s
> > In file included from 
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/s390/kernel/asm-offsets.c:7:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h: In
> > function 'spin_needbreak':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:1931:
> > error: implicit declaration of function '__raw_spin_is_contended'
> > make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1
> > 
> > <--  snip  -->
> 
> Defining GENERIC_LOCKBREAK in arch/s390/Kconfig takes care of it. I'll 
> cook up a patch and queue it in git390.

thanks!

	Ingo
