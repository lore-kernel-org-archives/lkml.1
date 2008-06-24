Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYFXMG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYFXMG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFXMGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:06:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYFXMGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:06:52 -0400
Date: Tue, 24 Jun 2008 14:06:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softirq softlockup debugging
Message-ID: <20080624120639.GB10550@elte.hu>
References: <20080622122845.GA10133@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622122845.GA10133@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> I'm debugging a problem with a softirq that gets stuck for a long 
> time, so I wrote this patch to help find out what's going wrong.
> 
> I actually think it can be useful in general as well, see for example 
> http://www.kerneloops.org/search.php?search=__do_softirq&btnG=Function+Search
> 
> ..and these cases are virtually impossible to debug since we don't 
> know anything about *what* it was that got stuck. (The NMI watchdog 
> could help, though.)
> 
> The patch is #ifdef-ugly, I know... Suggestions are welcome.

i've applied it to tip/core/softlockup to give it some testing. (It 
needed a manual merge due to changes pending in that topic already)

	Ingo
