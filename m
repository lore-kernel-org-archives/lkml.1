Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbYKKSn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbYKKSn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYKKSnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:43:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYKKSnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:43:18 -0500
Date: Tue, 11 Nov 2008 19:43:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Message-ID: <20081111184311.GA21151@elte.hu>
References: <49191C31.1050402@gmail.com> <20081111094312.GA16496@elte.hu> <c62985530811110730x13bc92abo891b49934ea2ae6f@mail.gmail.com> <20081111171455.GA8201@elte.hu> <c62985530811110924p28d3ff7i3ce8ff0d86ca2fb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811110924p28d3ff7i3ce8ff0d86ca2fb8@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > at the risk of bikeshed-painting this issue too much, the problem 
> > with function_return is that it has little meaning to actual users 
> > and even to developers. What does the "return" mean? We know what 
> > it means, because we know that opposed to function entry we'll 
> > also capture function returns, and hence be able to do full 
> > function call tracing.
> >
> > so function_full i thought to conduct this aspect of it better. 
> > But suggestions are welcome.
> 
> 
> Ok. Let's change into function_full, after all, I think that this 
> tool will be mostly used with a parsing pass of its traces with a 
> script to produce statistics and hierarchical representation like 
> does draw_functrace.py After that, the order of apparition of the 
> functions in the trace will not really matter.

how about function_cost ?

that's what it's primarily about at this stage: the ability to capture 
entry+exit, and have the cost printed.

as opposed to function tracer, which traces function entry events, but 
does not try to build a coherent picture about per function execution 
cost.

	Ingo
