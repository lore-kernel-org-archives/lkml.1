Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZF2RMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZF2RMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZF2RMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:12:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZF2RMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:12:05 -0400
Subject: Re: [tip:perfcounters/urgent] perf stat: Improve output
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <tip-6e750a8fc009fd0ae98704525d1d8e80d60e8cc9@git.kernel.org>
References: <1246051927.2988.10.camel@hpdv5.satnam>
	 <tip-6e750a8fc009fd0ae98704525d1d8e80d60e8cc9@git.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 19:11:31 +0200
Message-Id: <1246295491.17061.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 17:31 +0000, tip-bot for Jaswinder Singh Rajput
wrote:
> Before:
>          150708  L1-d$-stores          (scaled from 23.57%)
>          428804  L1-d$-prefetches      (scaled from 23.47%)
>          314446  L1-d$-prefetch-misses  (scaled from 23.42%)
>       252626137  L1-i$-loads           (scaled from 23.24%)
>         5297550  dTLB-load-misses      (scaled from 23.96%)
>       106992392  branch-loads          (scaled from 23.67%)
>         5239561  branch-load-misses    (scaled from 23.43%)
> 
> After:
>         1731713  L1-d$-loads               (  14.25x scaled)
>           44241  L1-d$-prefetches          (   3.88x scaled)
>           21076  L1-d$-prefetch-misses     (   3.40x scaled)
>         5789421  L1-i$-loads               (   3.78x scaled)
>           29645  dTLB-load-misses          (   2.95x scaled)
>          461474  branch-loads              (   6.52x scaled)
>            7493  branch-load-misses        (  26.57x scaled)

I really rather like the before better. Its far easier to get a feel for
the overload factor from a fraction that from this multiplier.



