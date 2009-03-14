Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZCNNQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZCNNQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZCNNQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:16:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbZCNNQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:16:12 -0400
Date: Sat, 14 Mar 2009 14:15:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -tip 1/2] mm: introduce debug_kmap_atomic
Message-ID: <20090314131555.GB17727@elte.hu>
References: <20090311143317.GA22244@localhost.localdomain> <tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org> <20090314041948.GA3697@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314041948.GA3697@localhost.localdomain>
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


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> On Fri, Mar 13, 2009 at 01:39:31AM +0000, Ingo Molnar wrote:
> > x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn(), fix
> > 
> > Impact: build fix
> > 
> > Move kmap_atomic_prot_pfn() to iomap_32.c. It is used on all 32-bit
> > kernels, while highmem_32.c is only built on highmem kernels.
> 
> Thanks for fixing that.
> 
> > ( Note: the debug_kmap_atomic_prot() check is removed for now, that
> >   problem is handled via another patch. )
> 
> The patches are now sitting in -mmotm now. For -tip, here are the rebased
> patches for the debug_kmap_atomic_prot() check.

Due to the other-arch changes it's better to keep them in -mm i 
guess. Once the current batch goes out to linux-next (in the 
next few days) Andrew could pick up the two -tip patches you 
posted here.

	Ingo
