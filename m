Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYFYQnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYFYQnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYFYQnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:43:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58019 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYFYQnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:43:13 -0400
Date: Wed, 25 Jun 2008 18:43:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Merge setup_32/64.c into setup.c
Message-ID: <20080625164300.GC6040@elte.hu>
References: <200806242213.15310.yhlu.kernel@gmail.com> <200806242214.09503.yhlu.kernel@gmail.com> <200806250114.09858.yhlu.kernel@gmail.com> <20080625153614.GB18796@elte.hu> <86802c440806250844s51b50311va1c8e9c9fc1da510@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806250844s51b50311va1c8e9c9fc1da510@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >>  include/asm-x86/setup.h    |    2
> >>  5 files changed, 670 insertions(+), 934 deletions(-)
> >
> > very nice!
> >
> > could we please split this up into several, gradual steps that bring
> > setup_32.c and setup_64.c to exactly the same content - where the final
> > patch just renames arch/x86/kernel/setup_32.c to arch/x86/kernel/setup.c
> > and deletes arch/x86/kernel/setup_64.c ?
> 
> OK, someone (Mike Triavis) already stole setup.c for X86_NUMA.
> 
> You need to change that setup.c to other name. or split it away...

hm, that change was supposed to be the seed of a unification. So if it 
actually hinders you, feel free to move it to a different file. 
Obviously it is setup_32.c and setup_64.c that should be unified into 
setup.c.

	Ingo
