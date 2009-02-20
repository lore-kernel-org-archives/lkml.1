Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZBTJz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZBTJz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 04:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZBTJzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 04:55:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbZBTJzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:55:49 -0500
Date: Fri, 20 Feb 2009 10:55:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090220095530.GA15186@elte.hu>
References: <499DD40F.40102@kernel.org> <20090220095127.GK24555@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220095127.GK24555@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> >  arch/x86/kernel/apic/apic.c           |    3 +--
> >  arch/x86/kernel/apic/x2apic_cluster.c |    5 ++++-
> >  arch/x86/kernel/apic/x2apic_phys.c    |    5 ++++-
> >  arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
> >  drivers/pci/dmar.c                    |    3 ++-
> >  5 files changed, 14 insertions(+), 6 deletions(-)
> 
> I've applied it because it fixes a real bug, but this code 
> really needs a cleanup. Look at the repeat patterns:

unapplied it again as it breaks the build:

arch/x86/kernel/apic/x2apic_cluster.c: In function 'x2apic_acpi_madt_oem_check':
arch/x86/kernel/apic/x2apic_cluster.c:17: error: 'disable_x2apic' undeclared (first use in this function)
arch/x86/kernel/apic/x2apic_cluster.c:17: error: (Each undeclared identifier is reported only once
arch/x86/kernel/apic/x2apic_cluster.c:17: error: for each function it appears in.)

so please resend the fixed and cleaned up version.

Thanks,

	Ingo
