Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbXFDUVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbXFDUVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXFDUUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:20:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60533 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbXFDUUy (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:20:54 -0400
Date: Mon, 4 Jun 2007 22:20:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604202039.GA27149@elte.hu>
References: <20070604173710.GR11166@waste.org> <20070604181151.GA1745@elte.hu> <20070604184224.GH11115@waste.org> <20070604191229.GA12444@elte.hu> <20070604192755.GI11115@waste.org> <20070604194038.GA15782@elte.hu> <20070604195951.GJ11115@waste.org> <20070604201300.GB21261@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604201300.GB21261@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > I suggest you try this yourself [...]
> 
> yep, i know how to use lguest and i'm already running it :) But i 
> cannot trigger the problem, that's why i was curious about your 
> host-side stats.

i can run a hundred CPU hogs on the host and the lguest instance is 
still usable under CFS:

 @%@%> time ls
 bin         home        lost+found  proc        sys         var
 dev         lib         mnt         root        tmp
 etc         linuxrc     opt         sbin        usr
 real    0m 0.33s
 user    0m 0.00s
 sys     0m 0.00s

i'm wondering whether the delay goes away if you boot with maxcpus=1? 
(if you have multiple cpus/cores on your box)

	Ingo
