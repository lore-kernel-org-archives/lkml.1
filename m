Return-Path: <linux-kernel-owner+w=401wt.eu-S1762991AbZFKLzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762991AbZFKLzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZFKLzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:55:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZFKLzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:55:10 -0400
Date: Thu, 11 Jun 2009 13:54:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
Message-ID: <20090611115423.GA4963@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <20090611113512.GA6971@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611113512.GA6971@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] I started testing it on 6 boxes - if you dont hear from me 
> within a few hours it's all fine.

Quick runtime test summary:

 - 3 boxes produced the boot warning
 - two crashed (both 32-bit - i guess the WP test crash)
 - one booted up fine

So there's widespread breakage on x86, i'd suggest holding off on 
this for another day, so that we can get it fixed and tested some 
more.

I still like patches of course! :-)

	Ingo
