Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYJ2Htj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYJ2Htj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYJ2Hta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:49:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYJ2Hta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:49:30 -0400
Date: Wed, 29 Oct 2008 08:49:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for October 28
Message-ID: <20081029074913.GD17992@elte.hu>
References: <20081028183055.fbcf5420.sfr@canb.auug.org.au> <20081028160045.2a890509.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028160045.2a890509.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 28 Oct 2008 18:30:55 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> x86_64 allnoconfig:
> 
> arch/x86/kernel/genx2apic_uv_x.c: In function 'uv_rtc_init':
> arch/x86/kernel/genx2apic_uv_x.c:355: error: implicit declaration of function 'uv_bios_freq_base'
> arch/x86/kernel/genx2apic_uv_x.c: In function 'uv_system_init':
> arch/x86/kernel/genx2apic_uv_x.c:438: error: implicit declaration of function 'uv_bios_init'
> arch/x86/kernel/genx2apic_uv_x.c:439: error: implicit declaration of function 'uv_bios_get_sn_info'
> arch/x86/kernel/genx2apic_uv_x.c:439: error: 'uv_type' undeclared (first use in this function)
> arch/x86/kernel/genx2apic_uv_x.c:439: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/genx2apic_uv_x.c:439: error: for each function it appears in.)
> arch/x86/kernel/genx2apic_uv_x.c:439: error: 'sn_partition_id' undeclared (first use in this function)
> arch/x86/kernel/genx2apic_uv_x.c:440: error: 'uv_coherency_id' undeclared (first use in this function)
> arch/x86/kernel/genx2apic_uv_x.c:440: error: 'uv_region_size' undeclared (first use in this function)
> make[1]: *** [arch/x86/kernel/genx2apic_uv_x.o] Error 1
> make: *** [arch/x86/kernel/genx2apic_uv_x.o] Error 2
> 
> 
> Guys, allnoconfig breakage is very common.  It's easy to configure and
> is very quick to test.  Please use it.

i test allnoconfig multiple times a day.

By the looks of it i suspect Git left around some stale file which 
fooled my testing? Checking now.

	Ingo
