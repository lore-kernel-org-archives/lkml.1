Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZCRQfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZCRQfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZCRQfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:35:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbZCRQfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:35:42 -0400
Date: Wed, 18 Mar 2009 17:35:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: oops in tracepoint_update_probe_range() (was: Re: [oops -tip] :
	x86 AMD 64)
Message-ID: <20090318163531.GE21331@elte.hu>
References: <1237393396.3322.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237393396.3322.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Good: f4c3c4cdb1de232
> Bad : 1e08816af0bc345
> 
> Config:
> http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
> 
> oops:
> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
> 
> <freeze>

Steve, Frederic - the crashes above are in:

	tracepoint_update_probe_range()

in a modular kernel apparently.

	Ingo
