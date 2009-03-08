Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZCHWMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZCHWMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZCHWMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:12:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51510 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbZCHWMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:12:32 -0400
Date: Sun, 8 Mar 2009 23:12:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090308221208.GA24079@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org> <20090302120859.GB29015@elte.hu> <49B23907.8030103@goop.org> <20090308110150.GA19151@elte.hu> <49B43F1D.2000400@zytor.com> <20090308220609.GA23447@elte.hu> <49B441D9.4010004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B441D9.4010004@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> > 
> > Since it's the same kernel image i think the only truly reliable 
> > method would be to reboot between _different_ kernel images: 
> > same instructions but randomly re-align variables both in terms 
> > of absolute address and in terms of relative position to each 
> > other. Plus randomize bootmem allocs and never-gets-freed-really 
> > boot-time allocations.
> > 
> > Really hard to do i think ...
> > 
> 
> Ouch, yeah.
> 
> On the other hand, the numbers made sense to me, so I don't 
> see why there is any reason to distrust them.  They show a 5% 
> overhead with pv_ops enabled, reduced to a 2% overhead with 
> the changed.  That is more or less what would match my 
> intuition from seeing the code.

Yeah - it was Jeremy expressed doubt in the numbers, not me.

And we need to eliminate that 2% as well - 2% is still an awful 
lot of native kernel overhead from a kernel feature that 95%+ of 
users do not make any use of.

	Ingo
