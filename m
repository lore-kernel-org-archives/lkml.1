Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZAMAQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZAMAQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZAMAPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:15:55 -0500
Received: from relay3.sgi.com ([192.48.171.31]:53645 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbZAMAPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:15:54 -0500
Message-ID: <496BDD37.7030005@sgi.com>
Date: Mon, 12 Jan 2009 16:15:51 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc	cpumask_var_t's.
References: <20090112220519.566749000@polaris-admin.engr.sgi.com> <20090112222123.GB15294@elte.hu>
In-Reply-To: <20090112222123.GB15294@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo - should I push these to tip/cpus4096 via the cpus4096-for-ingo 
>> tree since that has the relevant changes to irq_desc?  Or by some other 
>> means?
> 
> yes, please update cpus4096-for-ingo so that i can pull it from your tree.
> 
> 	Ingo

Hi Ingo,

Here's the consolidated patches for the irq_desc cpumask changes.  There was
one small test merge conflict w/tip-master in kernel/irq/handle.c that I was not
sure how to 'pre-fix' from this end.

Also, I'm still hunting down that mail about the cross build tools.

Thanks!
Mike


The following changes since commit 28e08861b9afab4168b758fb7b95aa7a4da0f668:
  Christophe Saout (1):
        xen: fix too early kmalloc call

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Mike Travis (1):
      irq: update all arches for new irq_desc

 arch/alpha/kernel/irq.c               |    2 +-
 arch/arm/kernel/irq.c                 |   18 ++++++++++++------
 arch/arm/oprofile/op_model_mpcore.c   |    2 +-
 arch/blackfin/kernel/irqchip.c        |    5 +++++
 arch/ia64/kernel/iosapic.c            |    2 +-
 arch/ia64/kernel/irq.c                |    4 ++--
 arch/ia64/kernel/msi_ia64.c           |    4 ++--
 arch/ia64/sn/kernel/msi_sn.c          |    2 +-
 arch/mips/include/asm/irq.h           |    2 +-
 arch/mips/kernel/irq-gic.c            |    2 +-
 arch/mips/kernel/smtc.c               |    2 +-
 arch/mips/mti-malta/malta-smtc.c      |    5 +++--
 arch/parisc/kernel/irq.c              |    8 ++++----
 arch/powerpc/kernel/irq.c             |    2 +-
 arch/powerpc/platforms/pseries/xics.c |    5 +++--
 arch/powerpc/sysdev/mpic.c            |    3 ++-
 arch/sparc/kernel/irq_64.c            |    5 +++--
 17 files changed, 44 insertions(+), 29 deletions(-)

