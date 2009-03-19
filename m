Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZCSPve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZCSPve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZCSPvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:51:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbZCSPvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:51:17 -0400
Date: Thu, 19 Mar 2009 16:50:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range()
Message-ID: <20090319155050.GB21034@elte.hu>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com> <20090319074616.GA17144@elte.hu> <20090319132248.GA20200@Krystal> <alpine.DEB.2.00.0903190933440.16987@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903190933440.16987@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 19 Mar 2009, Mathieu Desnoyers wrote:
> > 
> > Jaswinder : maybe you have old modules in your /lib/modules/`uname -r`
> > directory which have the correct version, but the wrong module.h header ?
> 
> Isn't there a module versioning that prevents such things?

It can be overriden. In any case, the NULL check we have there now 
makes sense.

	Ingo
