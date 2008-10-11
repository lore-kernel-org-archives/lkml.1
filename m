Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbYJKST0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbYJKST0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbYJKSTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:19:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46424 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844AbYJKSTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:19:18 -0400
Date: Sat, 11 Oct 2008 20:18:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull, take 2] x86 updates for v2.6.28, phase #4, x2apic,
	unify-cpu-detect
Message-ID: <20081011181857.GA20554@elte.hu>
References: <20081010000408.GA5970@elte.hu> <20081010175613.GA20112@elte.hu> <alpine.LFD.2.00.0810111108060.3402@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810111108060.3402@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 10 Oct 2008, Ingo Molnar wrote:
> > 
> > Please pull the latest x86-v28-for-linus-phase4-B git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase4-B
> 
> This is broken.
> 
> I get an absolute metric shitload of:
> 
> 	include/asm/dma-mapping.h:309:2: error: #endif without #if
> 
> errors, and I suspect it's because of some broken merge resolution 
> that you didn't even test and then fixed in some later branch.

possible - i tested the first series at all 10 merge points for 3 days.

and indeed the problem is not there in the old, x86-v28-for-linus-phase4 
branch.

> I double-checked: it's already broken in your tree, it's not from my 
> merge (ie commit 0d4ab8b5aa74f6be4d022dcf5e27845b7c290294 is already 
> showing that bug).
> 
> Not pulled.

indeed:

 #endif
 #endif /* ASM_X86__DMA_MAPPING_H */

that goes away in x86-v28-for-linus-phase6-B.

	Ingo
