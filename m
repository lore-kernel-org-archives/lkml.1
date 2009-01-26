Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZAZWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZAZWLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZAZWLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:11:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbZAZWLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:11:13 -0500
Date: Mon, 26 Jan 2009 23:10:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Papi <ptools-perfapi@cs.utk.edu>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Paul Mackerras <paulus@samba.org>,
       Peter Anvin <hpa@zytor.com>, "eranian@gmail.com" <eranian@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "perfmon2-devel@lists.sourceforge.net" 
	<perfmon2-devel@lists.sourceforge.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [perfmon2] [announce] Performance Counters for Linux, v6
Message-ID: <20090126221038.GA7440@elte.hu>
References: <20090121185021.GA8852@elte.hu> <497D0C81.5040406@linux.vnet.ibm.com> <7c86c4470901260113r4db6b15cpa0fa88ab3f8a516c@mail.gmail.com> <20090126151746.GH9128@elte.hu> <497E0B55.4050408@linux.vnet.ibm.com> <57C9024A16AD2D4C97DC78E552063EA35F1F9374@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35F1F9374@orsmsx505.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> > - or the PMU capability is expressed as a special counter type (if it's
> >   useful enough) - and then either the write() method or ioctl is extended
> >   to express attributes we want to set/change while a counter is running.
> 
> The product of:
>         {exotic PMU modes} * {creative performance measurement ideas}
>
> will produce a large number of candidates for these special counters (at 
> least on ia64 ... which has a large number of exotic PMU options).
> 
> I don't think that I'm qualified to judge which of them are "useful 
> enough" to warrant a special counter type.

it should certainly be done on a case by case basis. They need to be 
consciously exposed not just summarily exported to user-space, because PMU 
hw features have security implications so it has to be done all 
explicitly.

	Ingo
