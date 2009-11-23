Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbZKWREp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbZKWREp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZKWREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:04:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZKWREo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:04:44 -0500
Date: Mon, 23 Nov 2009 18:04:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123170445.GA29058@elte.hu>
References: <20091123112228.GA2287@wotan.suse.de>
 <1258987059.6193.73.camel@marge.simson.net>
 <20091123151152.GA19175@wotan.suse.de>
 <1258989704.4531.574.camel@laptop>
 <20091123152931.GD19175@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123152931.GD19175@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > .32 is kind of closed, with us being at -rc8.
> 
> It's a bad regression though.

It's about 3 months too late for that. Ideally we want performance 
regressions to be looked for and reported when the patches go into the 
devel tree. Failing that, -rc1 would be the good time to re-test 
whatever workload you care about.

If you cannot test it in a regular fashion you can offload the testing 
to us, by adding a similar/equivalent workload to 'perf bench sched'. 
We'll make sure it stays sane.

Thanks,

	Ingo
