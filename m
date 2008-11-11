Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYKKKo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYKKKo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYKKKos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:44:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43028 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbYKKKor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:44:47 -0500
Date: Tue, 11 Nov 2008 11:44:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] sched: Include group statistics in
	/proc/sched_debug
Message-ID: <20081111104441.GE10554@elte.hu>
References: <20081110092350.GA3679@in.ibm.com> <1226309407.2697.4034.camel@twins> <20081110160409.GB3933@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110160409.GB3933@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> > Why not simply add them to the cfs_rq[n]:/path sections we already 
> > have?
> 
> Makes sense. Here is the updated patch which puts group statistics 
> under cfs_rq[n]:/path section as you suggest.
> 
> Include group statistics in /proc/sched_debug.

applied to tip/sched/core, thanks Bharata!

	Ingo
