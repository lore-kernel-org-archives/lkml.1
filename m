Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZERRK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZERRK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZERRKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:10:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZERRKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:10:20 -0400
Date: Mon, 18 May 2009 19:09:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090518170909.GA1623@elte.hu>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 18 May 2009, Ingo Molnar wrote:
> > 
> > hm - i've Cc:-ed Jeff & Viro. The background is that Sparse and LLVM 
> > barfed on the current construct and Al strongly advocated this 
> > solution, see:
> 
> I know the background.
> 
> Did you read my email?
> 
> Did you see my one-line patch that fixes the same problem WITHOUT 
> THE INSANITY?

Yes, i even proposed that very patch in the original discussion, in 
my first reply:

    http://lkml.org/lkml/2009/5/8/378

but then got sidetracked by the 'this is C-correct' claim. Should 
have noticed the bogosity, sorry about that.

	Ingo
