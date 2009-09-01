Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZIANJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZIANJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZIANJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:09:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47128 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbZIANJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:09:56 -0400
Date: Tue, 1 Sep 2009 15:09:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
	Fix a race on perf_counter_ctx
Message-ID: <20090901130942.GA10206@elte.hu>
References: <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com> <1250602664.7583.293.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com> <20090818140022.GB13013@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com> <1251810046.7547.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251810046.7547.13.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > In any case, this is getting late for the upcoming merge window. 
> > Would you rather drop the BTS patch or disable kernel tracing?
> 
> I don't think we need to drop it, at worst we could defer the 
> patch to .33, but I think we can indeed get away with disabling 
> the kernel tracing for now.

That could be done via a simple patch that does not enable BTS 
tracing if the .kernel attribute bit is set. I.e. we enable BTS on a 
narrower set of config settings than in the past - but still keep 
the code largely untouched.

	Ingo
