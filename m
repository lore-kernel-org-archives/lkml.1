Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbZAWJRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbZAWJRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZAWJRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:17:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZAWJRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:17:11 -0500
Date: Fri, 23 Jan 2009 10:16:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: Merge hardirq.h
Message-ID: <20090123091658.GA29820@elte.hu>
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com> <497926C2.4090203@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497926C2.4090203@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Brian Gerst wrote:
> > This patch series merges the 32-bit and 64-bit hardirq.h headers and
> > does several associated cleanups.  Based on tip/core/percpu.
> > 
> >  arch/x86/include/asm/hardirq.h    |   49 ++++++++++++++++++++++++++++++++++---
> >  arch/x86/include/asm/hardirq_32.h |   33 -------------------------
> >  arch/x86/include/asm/hardirq_64.h |   39 -----------------------------
> >  arch/x86/kernel/efi_64.c          |    1 +
> >  arch/x86/kernel/irq_64.c          |    1 +
> >  arch/x86/kernel/process_32.c      |    1 -
> >  6 files changed, 47 insertions(+), 77 deletions(-)
> 
> Patch tree reviewed and imported into the following git tree (sync seems 
> slow today if it doesn't appear please pull directly from master)
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Pulled into tip/core/percpu, thanks guys!

	Ingo
