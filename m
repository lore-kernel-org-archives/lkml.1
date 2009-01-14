Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZANLPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZANLPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZANLPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:15:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbZANLPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:15:06 -0500
Date: Wed, 14 Jan 2009 12:14:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc
	cpumask_var_t's.
Message-ID: <20090114111440.GM2913@elte.hu>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com> <20090112222123.GB15294@elte.hu> <496BDD37.7030005@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BDD37.7030005@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Ingo - should I push these to tip/cpus4096 via the cpus4096-for-ingo 
> >> tree since that has the relevant changes to irq_desc?  Or by some other 
> >> means?
> > 
> > yes, please update cpus4096-for-ingo so that i can pull it from your tree.
> > 
> > 	Ingo
> 
> Hi Ingo,
> 
> Here's the consolidated patches for the irq_desc cpumask changes.  There was
> one small test merge conflict w/tip-master in kernel/irq/handle.c that I was not
> sure how to 'pre-fix' from this end.
> 
> Also, I'm still hunting down that mail about the cross build tools.
> 
> Thanks!
> Mike
> 
> 
> The following changes since commit 28e08861b9afab4168b758fb7b95aa7a4da0f668:
>   Christophe Saout (1):
>         xen: fix too early kmalloc call
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master
> 
> Mike Travis (1):
>       irq: update all arches for new irq_desc
> 
>  arch/alpha/kernel/irq.c               |    2 +-
>  arch/arm/kernel/irq.c                 |   18 ++++++++++++------
>  arch/arm/oprofile/op_model_mpcore.c   |    2 +-
>  arch/blackfin/kernel/irqchip.c        |    5 +++++
>  arch/ia64/kernel/iosapic.c            |    2 +-
>  arch/ia64/kernel/irq.c                |    4 ++--
>  arch/ia64/kernel/msi_ia64.c           |    4 ++--
>  arch/ia64/sn/kernel/msi_sn.c          |    2 +-
>  arch/mips/include/asm/irq.h           |    2 +-
>  arch/mips/kernel/irq-gic.c            |    2 +-
>  arch/mips/kernel/smtc.c               |    2 +-
>  arch/mips/mti-malta/malta-smtc.c      |    5 +++--
>  arch/parisc/kernel/irq.c              |    8 ++++----
>  arch/powerpc/kernel/irq.c             |    2 +-
>  arch/powerpc/platforms/pseries/xics.c |    5 +++--
>  arch/powerpc/sysdev/mpic.c            |    3 ++-
>  arch/sparc/kernel/irq_64.c            |    5 +++--
>  17 files changed, 44 insertions(+), 29 deletions(-)

Pulled into tip/cpus4096, thanks Mike!

	Ingo
