Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJ2IWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJ2IWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYJ2IWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:22:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYJ2IWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:22:14 -0400
Date: Wed, 29 Oct 2008 09:21:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: linux-next: Tree for October 28
Message-ID: <20081029082156.GF17992@elte.hu>
References: <20081028183055.fbcf5420.sfr@canb.auug.org.au> <20081028160045.2a890509.akpm@linux-foundation.org> <20081028162345.72b3180f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028162345.72b3180f.akpm@linux-foundation.org>
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

> On Tue, 28 Oct 2008 16:00:45 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > I have created today's linux-next tree at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > 
> > x86_64 allnoconfig:
> > 
> > arch/x86/kernel/genx2apic_uv_x.c: In function 'uv_rtc_init':
> > arch/x86/kernel/genx2apic_uv_x.c:355: error: implicit declaration of function 'uv_bios_freq_base'
> 
> oop, seems that this was caused by the presence of a stale
> include/asm-x86/uv/bios.h.

oh well, i just wasted half an hour trying to reproduce that build bug 
on various trees :-/

but it wasnt a wasted effort: i found a deficiency in my allnoconfig 
testing scripts.

	Ingo
