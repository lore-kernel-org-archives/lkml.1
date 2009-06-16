Return-Path: <linux-kernel-owner+w=401wt.eu-S1761163AbZFPHpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163AbZFPHpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZFPHpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:45:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60279 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZFPHpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:45:06 -0400
Date: Tue, 16 Jun 2009 09:44:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the slab tree
Message-ID: <20090616074446.GA10278@elte.hu>
References: <20090616154652.b8adcb9d.sfr@canb.auug.org.au> <1245131318.3415.1.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245131318.3415.1.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 2009-06-16 at 15:46 +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the tip tree got a conflict in mm/slub.c
> > between commit 964cf35c88f93b4927dbc4e950dfa4d880c7f9d1 ("SLUB: Fix early
> > boot GFP_DMA allocations") from the slab tree and commit
> > 18fd427debcf37c06917b55295df682fd05fee76 ("slub: add hooks for
> > kmemcheck") from the tip tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> Looks good! Thanks.

Btw., this SLAB commit is for this merge window, right?

	Ingo
