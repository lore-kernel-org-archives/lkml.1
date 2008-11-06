Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYKFPQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYKFPQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYKFPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:16:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYKFPQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:16:23 -0500
Date: Thu, 6 Nov 2008 16:15:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 5/7] x86_64: Support for cpu ops
Message-ID: <20081106151558.GB1644@elte.hu>
References: <20081105231634.133252042@quilx.com> <20081105231649.108433550@quilx.com> <20081106071206.GH15731@elte.hu> <Pine.LNX.4.64.0811060907570.3595@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811060907570.3595@quilx.com>
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


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 6 Nov 2008, Ingo Molnar wrote:
> 
> > hm, what happened to the rebase-PDA-to-percpu-area optimization 
> > patches you guys were working on? I remember there was some 
> > binutils flakiness - weird crashes and things like that. Did you 
> > ever manage to stabilize it? It would be sad if only 32-bit could 
> > take advantage of the optimized ops.
> 
> I thought that was in your tree? I saw a conflict in -next with the 
> zero based stuff a couple of weeks ago. Mike is working on that 
> AFAICT.

No, what's in tip/core/percpu is not the PDA patches:

 f8d90d9: percpu: zero based percpu build error on s390
 cfcfdff: Merge branch 'linus' into core/percpu
 d379497: Zero based percpu: infrastructure to rebase the per cpu area to zero
 b3a0cb4: x86: extend percpu ops to 64 bit

But it's not actually utilized on x86. AFAICS you guys never came back 
with working patches for that (tip/x86/percpu is empty currently), and 
now i see something related on lkml on a separate track not Cc:-ed to 
the x86 folks so i thought i'd ask whether more coordination is 
desired here.

So ... what's the merge plan here? I like your fundamental idea, it's 
a nice improvement in a couple of areas and i'd like to help out make 
it happen. Also, the new per-cpu allocator would be nice for the 
sparseirq code.

	Ingo
