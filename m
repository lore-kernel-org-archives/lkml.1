Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZAMQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZAMQmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZAMQml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:42:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZAMQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:42:40 -0500
Date: Tue, 13 Jan 2009 17:42:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL]: please pull changes for tip/cpus4096
Message-ID: <20090113164227.GA28034@elte.hu>
References: <496BF1DC.2080009@sgi.com> <20090113151336.GA5431@elte.hu> <496CB0D2.2010300@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496CB0D2.2010300@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Hi Ingo,
> >>
> >> This is the same as the previous pull request except that I added 
> >> Yinghai's vast improvement to probing for nr_irqs.  Big difference in 
> >> runtime memory allocated.
> > 
> > before moving on, we first need to fix all pending regressions. Such as 
> > some MAXSMP fallout from the cpufreq changes:
> 
> Ahh, ok, was this in my inbox already?

yes. Also, we first need to fix all regressions (such as the irq_desc 
affinity fallout) before piling up any new stuff. With a rolling upgrade 
there's never any point of stability, and bisectability suffers as well.

	Ingo
