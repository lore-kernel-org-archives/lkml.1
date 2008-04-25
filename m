Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbYDYIFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbYDYIFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbYDYIFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:05:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55257 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbYDYIEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:04:38 -0400
Date: Fri, 25 Apr 2008 10:04:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] scheduler/misc fixes
Message-ID: <20080425080421.GA14939@elte.hu>
References: <20080424225530.GA8717@elte.hu> <20080424.204620.88617191.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424.204620.88617191.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> Please also add the trivial regression fix I posted to you earlier, 
> included again below, you seem to be selectively reading email from me 
> and missing bug fix patches in the process.
> 
> sched: Use alloc_bootmem() instead of alloc_bootmem_low()

thanks David, i queued your fix up.

should we perhaps make alloc_bootmem_low() generate a warning instead of 
breaking the bootup? Especially on systems that have no physical RAM 
below 4GB at all the whole notion of 'lowmem' is meaningless.

	Ingo
