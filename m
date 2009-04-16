Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZDPJVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZDPJVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZDPJVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:21:23 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2977 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZDPJVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:21:22 -0400
Subject: Re: [PATCH 3/8] irq: make set_affinity to return status -v2
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090416090826.GG9813@elte.hu>
References: <49E68C41.4020801@kernel.org> <49E68CBC.8090507@kernel.org>
	 <20090416090826.GG9813@elte.hu>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 02:17:57 -0700
Message-Id: <1239873477.14053.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 11:08 +0200, Ingo Molnar wrote:
> >  arch/alpha/kernel/sys_dp264.c         |    8 +++-
> >  arch/alpha/kernel/sys_titan.c         |    4 +-
> >  arch/arm/common/gic.c                 |    4 +-
> >  arch/cris/arch-v32/kernel/irq.c       |    4 +-
> >  arch/ia64/hp/sim/hpsim_irq.c          |    3 +
> >  arch/ia64/kernel/iosapic.c            |   10 +++--
> >  arch/ia64/kernel/msi_ia64.c           |   16 +++++---
> >  arch/ia64/sn/kernel/irq.c             |    4 +-
> >  arch/ia64/sn/kernel/msi_sn.c          |    8 ++--
> >  arch/mips/cavium-octeon/octeon-irq.c  |    8 +++-
> >  arch/mips/include/asm/irq.h           |    2 -
> >  arch/mips/kernel/irq-gic.c            |    5 +-
> >  arch/mips/mti-malta/malta-smtc.c      |    4 +-
> >  arch/mips/sibyte/bcm1480/irq.c        |    8 ++--
> >  arch/mips/sibyte/sb1250/irq.c         |    8 ++--
> >  arch/parisc/kernel/irq.c              |    6 ++-
> >  arch/powerpc/platforms/pseries/xics.c |   12 +++---
> >  arch/powerpc/sysdev/mpic.c            |    4 +-
> >  arch/sparc/kernel/irq_64.c            |   12 ++++--
> >  arch/x86/kernel/apic/io_apic.c        |   64 +++++++++++++++++++++-------------
> >  drivers/parisc/iosapic.c              |    6 ++-
> >  drivers/xen/events.c                  |   12 +++---
> >  include/linux/irq.h                   |    2 -
> >  23 files changed, 140 insertions(+), 74 deletions(-)
[]
> There is one omission: this should be Cc:-ed to 
> linux-arch@vger.kernel.org, because it affects all architectures.

How is one supposed to know this tidbit?

