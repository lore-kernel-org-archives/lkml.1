Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYFSKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYFSKbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYFSKbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:31:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbYFSKbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:31:33 -0400
Date: Thu, 19 Jun 2008 12:30:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCHv5] SGI UV: TLB shootdown using broadcast assist unit -
	v5 delta
Message-ID: <20080619103051.GH15228@elte.hu>
References: <E1K8zIG-0006Fb-Fo@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K8zIG-0006Fb-Fo@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> TLB shootdown for SGI UV.
> 
> This patch brings the code in Ingo's latest (June 18,2008) to v5
> 
> v1: 6/2 original
> v2: 6/3 corrections/improvements per Ingo's review
> v3: 6/4 split atomic operations off to a separate patch (Jeremy's review)
> v4: 6/12 include <mach_apic.h> rather than <asm/mach-bigsmp/mach_apic.h>
>          (fixes a !SMP build problem)
>          fix the index on uv_table_bases[blade]
> v5: 6/18 corrections/improvements per Ingo's second and third reviews
>     (includes closing the security hole in uv_ptc_proc_write())
>     (and adds tlb_uv.o to the Makefile)
> 
> Diffed against 2.6.26-rc6

could you please send a delta patch against tip/x86/uv - or just 
tip/master? You can pick it all up from:

  http://people.redhat.com/mingo/tip.git/README

it's better to have all these delta patches in a consecutive way, as 
everything up to your previous version of v5 has already been tested 
pretty thoroughly on non-UV hardware and is ready to be pushed into 
linux-next.

I'd suggest you name the new delta patch as v6, as there's a "v5" patch 
applied already.

( Also, you might want to check whether tip/master properly works on
  your simulator - to double-check whether the integration of x86/uv 
  changes with other x86 changes went fine. )

Thanks,

	Ingo
