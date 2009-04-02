Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbZDBTVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbZDBTVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZDBTV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:21:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZDBTV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:21:28 -0400
Date: Thu, 2 Apr 2009 21:20:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: kerneltop: update to new
	ABI
Message-ID: <20090402192044.GB2455@elte.hu>
References: <20090402091319.407283141@chello.nl> <tip-373b153677f26a263ef297d77a5e045a31f6486c@git.kernel.org> <1238679305.3099.11.camel@ht.satnam> <1238680772.3099.13.camel@ht.satnam> <20090402181144.GB6340@elte.hu> <1238696579.3099.50.camel@ht.satnam> <20090402182833.GA32407@elte.hu> <1238697485.3099.58.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238697485.3099.58.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Thu, 2009-04-02 at 20:28 +0200, Ingo Molnar wrote:
> 
> > That is not what i suggested though. I suggested '-e 1' to mean to 
> > default to the more common case: hw counters. I.e.:
> > 
> >  -e 1    ==    -e 0:1
> >  -e 2    ==    -e 0:2
> >  -e 3    ==    -e 0:3
> >  ...
> > 
> > sw counters could be specified only via the longer form.
> > 
> 
> If someone want to see all supported event counters. Then what is 
> your suggestion, can we represent some shortcut for it.

the help text already displays something like that although it is 
not dynamic.

	Ingo
