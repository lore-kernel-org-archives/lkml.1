Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYDIPE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYDIPE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYDIPES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:04:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42801 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbYDIPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:04:18 -0400
Date: Wed, 9 Apr 2008 17:03:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jacek Luczak <difrost.kernel@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
Message-ID: <20080409150333.GA24451@elte.hu>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com> <20080409210936.ec8ea986.sfr@canb.auug.org.au> <20080409212719.7d834c13.sfr@canb.auug.org.au> <20080409113109.GA25186@elte.hu> <20080409145058.GA7648@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409145058.GA7648@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> | > It seems that commit 883a9fc4e5d9b0701f15d4e5a23608f942104721 
> | > ("x86: cleanup - rename VM_MASK to X86_VM_MASK") from the x86 tree 
> | > seems to have missed some places.
> | 
> | i think what happened is that some changes came in from other trees 
> | that reintroduced the old symbols?
> 
> actually, that is the only explanation I could find. The last time I 
> sent you patches to fixup *all* VM_MASK (wich were grep'ed on *latest 
> branch over *all* sources inside x86). So this all were settled down 
> by a few of my patches and /for shame on me/ yours fixups. So these 
> fixups were missed on merging.

no, the problem turned out to be that i kept those fixes too spread out, 
and part of them went into the x86/for-akpm portion of the tree, part of 
it went into x86/testing. Since all x86 developers work against 
x86/testing this was never a problem - only now did it become one when i 
shuffled patches and branch boundaries around. Such problems will go 
away once linux-next starts using x86/testing as well. In any case i 
moved your fixes together and fixed up the patch ordering as well.

	Ingo
